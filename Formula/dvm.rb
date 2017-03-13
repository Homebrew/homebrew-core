class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.8.2.tar.gz"
  sha256 "b8297aaf07ea797429800a46fa76b2377edd6f6a0e67d61effee275df356575e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fad028117df696bda1b86684fce38200cdeb9c907ce98f5428a3b677fcfcf8b" => :sierra
    sha256 "d82eaa88e2ec438d6a6247bc1b8be79dbbab67653a7119e352b9f03e60221055" => :el_capitan
    sha256 "112fed06eb04fb5d878083b8f1c7e45bd3c538b63937957cb86aa944e2d70ce1" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    # `make` has to be deparallelized due to the following errors:
    #   glide install
    #   fatal: Not a git repository (or any of the parent directories): .git
    #   CGO_ENABLED=0 go build ...
    #   dvm-helper/dvm-helper.go:16:2: cannot find package "github.com/blang/semver"
    #   make: *** [local] Error 1
    # Reported 17 Feb 2017: https://github.com/howtowhale/dvm/issues/151
    ENV.deparallelize

    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    # `depends_on "glide"` already has this covered
    inreplace "Makefile", %r{^.*go get github.com/Masterminds/glide.*$\n}, ""

    (buildpath/"src/github.com/howtowhale/dvm").install buildpath.children

    cd "src/github.com/howtowhale/dvm" do
      system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
      prefix.install "dvm.sh"
      bash_completion.install "bash_completion" => "dvm"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
      prefix.install_metafiles
    end
  end

  def caveats; <<-EOS.undent
    dvm is a shell function, and must be sourced before it can be used.
    Add the following command to your bash profile:
        [ -f #{opt_prefix}/dvm.sh ] && . #{opt_prefix}/dvm.sh
    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end
