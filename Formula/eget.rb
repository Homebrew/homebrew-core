class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "50a54b10a2643b4086588ea06e9f6be210581c7bbad8aa4eca0e513212aaa7a0"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d05e403af82f6a0ff2e33fd6285a0c6f2795a2cc5e938ceb8edc1bb4f72629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39fcb55bab666ce1a17fa2a3fcec183226bfc2e9b432c8c3181e1aed0dcc70f"
    sha256 cellar: :any_skip_relocation, ventura:        "840357fb3fd66665685cb7b1c394611d3a49253ccfdce9516fbd218b28dd38e9"
    sha256 cellar: :any_skip_relocation, monterey:       "21dec10c7e0886e5d69b81b8422b05e4f400b6a27eb3aef44b50a698608c9540"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f6e151bd7e6177899da7bc5fda8aa0a5d1c6a56fe6840e0a39371160cf6c8f1"
    sha256 cellar: :any_skip_relocation, catalina:       "c69bc2bf6c0d4de2696d79ed645f612430c80b1a85e58f000d6666e3a2f114eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc929d99692c5c07dd423aaefa0752dd124993508946e0a0586635db3da6557a"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
