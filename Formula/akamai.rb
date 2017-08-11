class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.3.1.tar.gz"
  sha256 "4de17bfde60de81cb5f290edc976bfb56d262a7acbc20b093fe0b3a2c406e1ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6204f0592245d0297cab5095fbd34dccd7d348f4d08760673a2bd1beb62e25b" => :sierra
    sha256 "74c6ec929a13034daa97fcc526316a40e35258259c7d48d9cf0786574e47ad2d" => :el_capitan
    sha256 "c1a4a981141dca33074a2b915682aa1213a9de5b80207abb2fe2dfba3f61d30f" => :yosemite
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
    end
  end

  test do
    assert_match "Purge", shell_output("yes y | #{bin}/akamai install purge")
  end
end
