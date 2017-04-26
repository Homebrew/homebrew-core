class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/online-net/c14-cli"
  url "https://github.com/online-net/c14-cli/archive/0.1.tar.gz"
  sha256 "cff3597273daff87e8d6e85cfef2b4d83400f0a0a905f39a4a67560b4966513c"
  head "https://github.com/online-net/c14-cli.git"

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
