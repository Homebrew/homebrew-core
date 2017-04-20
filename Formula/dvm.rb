class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/0.8.3.tar.gz"
  sha256 "f0fa2f8fc4532568ae5e624f983ebb7b60dc19749a9b531ae2279833a4bbce4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "db18f0bef6906ec06abc83d760a3a260f1457c5aadee7bf064c9b6adef16e5c2" => :sierra
    sha256 "28d0fe4c0c01241bbdbd074480648f232fad3818bd929ae900a917ffbf9af493" => :el_capitan
    sha256 "f0d0822caae95580d42407bb5b286ca9d5ebce3ea87e9e9f6a1dc377291bb86c" => :yosemite
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
