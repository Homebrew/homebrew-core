class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c6989579808d5fbfbceda87f303d90573e89cef5442d15fd249a6ad5de467004"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b79114520fb5ab62ca85e70bf7454b5b218dd85b978a2dc98ffa70d51edd67f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afe74381a6695ebea3b76c8d1b0473b16885ec3091262b9376726e7dccc0ab0f"
    sha256 cellar: :any_skip_relocation, monterey:       "898bd81c116d37d5480a096ea3aa10f3f5d6ad232200e3a92d5612bda6e64087"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead83e9f98f20e979890800ad2939044d88ed79f039d5d9f626a6e8dd4178572"
    sha256 cellar: :any_skip_relocation, catalina:       "414444926f6cc96e964303badadf7e4b505a563368f275306e99d8eec79b02b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb7ddc889548ebcb8100dec61b710e9ec080314e87812ddce3f0e8a08babe10"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
