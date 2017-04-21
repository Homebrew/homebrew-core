class C14 < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/online-net/c14-cli"
  url "https://github.com/online-net/c14-cli/archive/0.1.tar.gz"
  sha256 "cff3597273daff87e8d6e85cfef2b4d83400f0a0a905f39a4a67560b4966513c"
  head "https://github.com/online-net/c14-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80a12f0378bf0cc4d6821b9dd9c3381b89771e95f523d57d876b7d7e316affa1" => :sierra
    sha256 "792be6c0a7b700ad9ae6c618dde4e6e9fbf7a35e1c204ebf4d366c805d191cec" => :el_capitan
    sha256 "d5d5189fd3a4e2fcf368717e770a811f5a7c4558022b450fa330503b106d1c7e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/online-net/c14-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/c14", "-v", "-ldflags", "-X  github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew", "github.com/online-net/c14-cli/cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
