class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.5.1.tar.gz"
  sha256 "d39c4550ece219ac82f0475401fedcadf73dc65c46bb0f7169670f1cb5afbb1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "21733a07ff718017ed945fca44db55cec46c51537a023b2b4738223020f8e71a" => :high_sierra
    sha256 "649f6ae9c1f1c1e1a894d3134340562afb000c5a88b3342442656186ddd25166" => :sierra
    sha256 "b1d85c495f0a98b12b459be5fc6f94ea9ae8109cf9f62b179bb6c0a53e5d19f3" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
