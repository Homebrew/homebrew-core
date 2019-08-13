class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/scaleway/c14-cli"
  url "https://github.com/scaleway/c14-cli/archive/0.3.tar.gz"
  sha256 "d4a2e839394cb5f169bfb3be0102569a310dd7315aba3cdb1dfcd9d9c6e43543"
  head "https://github.com/scaleway/c14-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eed580ea37aefbc419ec97a233f07c79549c4a155d7bf4c4809c5034380c24f" => :mojave
    sha256 "4001f6779bdc27b3e3587e3a0502e65d94f78a6f108efd714b96c2d865bb592d" => :high_sierra
    sha256 "a146090fbcacb6982155419c4f8e38d9ccb8fa6283c5d2611ccf30ea1960ed84" => :sierra
    sha256 "399d93ad762d178607ca3da8d766cc4716ac33968c058a849f080d68dea634d7" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/online-net/c14-cli").install buildpath.children

    system "go", "build",
           "-ldflags", "-X github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew",
           "-o", bin/"c14",
           "github.com/online-net/c14-cli/cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
