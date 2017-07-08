class Hyperkit < Formula
  desc "Lightweight virtualization hypervisor for MacOS"
  homepage "https://github.com/moby/hyperkit"
  url "https://github.com/moby/hyperkit.git",
    :tag => "v0.20170425",
    :revision => "a9c368bed6003bee11d2cf646ed1dcf3d350ec8c"

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

  depends_on "opam"
  depends_on "libev"

  resource "tinycorelinux" do
    url "https://dl.bintray.com/markeissler/homebrew/hyperkit-kernel/tinycorelinux_8.x.tar.gz"
    sha256 "560c1d2d3a0f12f9b1200eec57ca5c1d107cf4823d3880e09505fcd9cd39141a"
  end

  def install
    ohai "Installing hyperkit dependencies with OPAM. This might take a while..."

    quiet_system <<-CMD.undent
      export OPAMYES=1
      opam init
      eval "$(opam config env)"
      opam install uri qcow.0.10.0 qcow-tool mirage-block-unix.2.7.0 conf-libev logs fmt mirage-unix prometheus-app
    CMD

    ohai "Dependencies installed."

    # update the Makefile to set version to X.YYYYmmdd (sha1)
    if build.head?
      command = <<-CMD.undent
        \\cd "#{buildpath}"; \
        \\git log -1 --pretty=format:"vHEAD.%cd-%h" --date=short "master"
      CMD
      version_string = system command.chomp
      version, sha1 = version_string.split("-", 3).join("").split("-")
    else
      # grab version and sha1 from stable resource specs
      version = stable.specs[:tag][0..-1]
      sha1 = stable.specs[:revision][0..6]
    end

    if version.nil? || version.empty? || sha1.nil? || sha1.empty?
      odie "Couldn't figure out which version we're building!"
    end

    quiet_system <<-CMD.undent
      \\sed -i".bak" \
      -e "s/GIT_VERSION[\ ]*:=.*/GIT_VERSION := '#{version} (#{sha1})'/g" \
      -e "s/GIT_VERSION_SHA1[\ ]:=.*/GIT_VERSION_SHA1 := '#{sha1}'/g" \
      "#{buildpath}/Makefile"
    CMD

    system "make"

    bin.install "build/hyperkit"
    man1.install "hyperkit.1"
  end

  test do
    # simple test when not in a vm that supports guests (i.e. VT-x disabled)
    unless Hardware::CPU.features.include? :vmx
      return system bin/"hyperkit", "-version"
    end

    # download tinycorelinux kernel and initrd, boot system, check for prompt
    resource("tinycorelinux").stage do |context|
      tmpdir = context.staging.tmpdir
      path_resource_versioned = Dir.glob(tmpdir.join("tinycorelinux_[0-9]*"))[0]
      cp(File.join(path_resource_versioned, "vmlinuz"), testpath)
      cp(File.join(path_resource_versioned, "initrd.gz"), testpath)
    end

    (testpath/"test_hyperkit.exp").write <<-EOS.undent
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
end
