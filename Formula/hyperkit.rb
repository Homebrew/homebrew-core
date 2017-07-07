class Hyperkit < Formula
  require "open3"

  desc "Lightweight virtualization hypervisor for MacOS"
  homepage "https://github.com/moby/hyperkit"

  # Retrieve version and commit hash from local git repo
  #
  # The tip of the specified branch will be examined to generate a version that
  # is consistent with a bonafide tagged release version string but where the
  # major version number is "HEAD" and the commit hash is simply the associated
  # commit hash for the tip of the branch.
  #
  # @example Example generated version string
  #   vHEAD.20170425
  #
  # @param [String] build_path repo directory
  # @param branch [String] target branch
  #
  # @return [Array] array containing version in field 1, commit hash in field 2
  #
  def self.version_from_git(build_path, branch = "master")
    command = <<-CMD.undent
      \\cd "#{build_path}"; \
      \\git log -1 --pretty=format:"vHEAD.%cd-%h" --date=short #{branch}
    CMD
    version_string, _stderr, _status = Open3.capture3(command.chomp)
    version_string.split("-", 3).join("").split("-")
  end

  # Retrieve version and commit hash from Resource object
  #
  # The resource must have the :tag and :revision fields defined in its specs
  # attribute.
  #
  # @param [Resource] resource target resource
  #
  # @return [Array] array containing version in field 1, commit hash in field 2
  #
  def self.version_from_resource(resource)
    if !resource.specs.key?(:tag) || resource.specs[:tag].to_s.empty?
      odie "Couldn't figure out version from resource!"
    end
    if !resource.specs.key?(:revision) || resource.specs[:revision].to_s.empty?
      odie "Couldn't figure out commit hash from resource!"
    end
    [resource.specs[:tag][0..-1], resource.specs[:revision][0..6]]
  end

  # Parse version and commit hash form url
  #
  # Url must be in the following format:
  #   https://dl.bintray.com/markeissler/homebrew/hyperkit/hyperkit-v0.20170515-fa78d94.tar.gz
  #
  # @param [String] url url to parse
  #
  # @return [Array] array containing version in field 1, commit hash in field 2
  #
  def self.version_from_url(url)
    url.scan(/hyperkit-(v[\d]{1}.[\d]{8})-([A-Fa-f\d]+).tar.gz$/).first
  end

  stable do
    url "https://github.com/moby/hyperkit.git",
      :tag => "v0.20170425",
      :revision => "a9c368bed6003bee11d2cf646ed1dcf3d350ec8c"
  end

  bottle do
    root_url "http://dl.bintray.com/markeissler/homebrew/bottles"
    cellar :any_skip_relocation
    sha256 "5cfa72e41bad9d812206a9850d7e6e63185ce1bffa0d1718beb5f09734d9bb29" => :sierra
    sha256 "32162cf81ca23a27f97e0fe0727ecc6f3dcf179716ac77fb9fbc38883e3d114f" => :el_capitan
    sha256 "0fb4cf0f9f8d81eb1be99d620b454ab14ec8680237f6938db095b032874e821d" => :yosemite
  end

  head do
    url "https://github.com/moby/hyperkit.git", :branch => "master"
  end

  depends_on "opam" => :run
  depends_on "libev" => :run

  resource "tinycorelinux" do
    url "https://dl.bintray.com/markeissler/homebrew/hyperkit-kernel/tinycorelinux_8.x.tar.gz"
    sha256 "560c1d2d3a0f12f9b1200eec57ca5c1d107cf4823d3880e09505fcd9cd39141a"
  end

  def install
    ohai "... Installing hyperkit dependencies with OPAM. This might take a while."

    system <<-CMD.undent
      export OPAMYES=1
      opam init
      eval "$(opam config env)"
      opam install uri qcow.0.10.0 qcow-tool mirage-block-unix.2.7.0 conf-libev logs fmt mirage-unix prometheus-app
    CMD

    ohai "... Dependencies installed."

    # update the Makefile to set version to X.YYYYmmdd-sha1
    if build.head?
      version, sha1 = Hyperkit.version_from_git(buildpath)
    else
      # no need to re-parse version, we already set it in stable declaration above
      version, sha1 = Hyperkit.version_from_resource(stable)
    end
    if version.nil? || version.empty? || sha1.nil? || sha1.empty?
      odie "Couldn't figure out which version we're building!"
    end
    update_makefile(buildpath, version, sha1)

    system "make"

    bin.install "build/hyperkit"
    man1.install "hyperkit.1"
  end

  test do
    #
    # Download tinycorelinux kernel and initrd, boot system, check for prompt.
    #
    ohai "... Running tests."

    resource("tinycorelinux").stage do |context|
      tmpdir = context.staging.tmpdir
      path_resource_versioned = Dir.glob(tmpdir.join("tinycorelinux_[0-9]*"))[0]
      cp(File.join(path_resource_versioned, "vmlinuz"), testpath)
      cp(File.join(path_resource_versioned, "initrd.gz"), testpath)
    end

    # boot tinycorelinux and check for a prompt
    (testpath/"test_hyperkit.exp").write strip_heredoc(<<-EOS)
      #!/usr/bin/env expect -d

      set KERNEL "./vmlinuz"
      set KERNEL_INITRD "./initrd.gz"
      set KERNEL_CMDLINE "earlyprintk=serial console=ttyS0"

      set MEM {512M}
      set PCI_DEV1 {0:0,hostbridge}
      set PCI_DEV2 {31,lpc}
      set LPC_DEV {com1,stdio}
      set ACPI {-A}

      spawn #{bin}/hyperkit $ACPI -m $MEM -s $PCI_DEV1 -s $PCI_DEV2 -l $LPC_DEV -f kexec,$KERNEL,$KERNEL_INITRD,$KERNEL_CMDLINE
      set pid [exp_pid]
      set timeout 20

      expect {
        timeout { puts "FAIL boot"; exec kill -9 $pid; exit 1 }
        "\\r\\ntc@box:~$ "
      }

      send "sudo halt\\r\\n";

      expect {
        timeout { puts "FAIL shutdown"; exec kill -9 $pid; exit 1 }
        "reboot: System halted"
      }

      expect eof

      puts "\\nPASS"
    EOS

    system "expect", "test_hyperkit.exp"
  end

  private

  # A more flexible version of undent, compress removes newlines
  def strip_heredoc(text, compress = false)
    stripped = text.gsub(/^#{text.scan(/^\s*/).min_by(&:length)}/, "")
    compress ? stripped.tr("\n", " ").chop : stripped
  end

  def update_makefile(build_path, version, sha1)
    system strip_heredoc(<<-CMD, true)
      \\sed -i".bak"
      -e "s/GIT_VERSION[\ ]*:=.*/GIT_VERSION := '#{version} (#{sha1})'/g"
      -e "s/GIT_VERSION_SHA1[\ ]:=.*/GIT_VERSION_SHA1 := '#{sha1}'/g"
      "#{build_path}/Makefile"
    CMD
  end
end