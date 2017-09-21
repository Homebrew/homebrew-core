class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/online-net/c14-cli"
  url "https://github.com/online-net/c14-cli/archive/0.1.tar.gz"
  sha256 "27f02f3146c2d239c44fe0cf3eb1a161d8bdb420145f13b8485c85d3892fd8f9"
  head "https://github.com/online-net/c14-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2da7668ade8257bf730b6d0a8c1da37469694779651289c198e8eac913cfebcf" => :high_sierra
    sha256 "5f933f312db20563688f11a278981c87e6771f16f7c3f3bccb29301b12e46bb6" => :sierra
    sha256 "94aa82618c853ee2f011e265e2131bce73e3cda2fcc2abacb4c64e2ebb325996" => :el_capitan
    sha256 "010ccda715de1b29406ee14d7439c33b17fc5741aa5c96439d01f2ce30f2431a" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/online-net/c14-cli").install Dir["*"]

    system "go", "build", "-ldflags",
           "-X  github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew",
           "-o", bin/"c14", "github.com/online-net/c14-cli/cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
