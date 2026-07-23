class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.108.0.tar.gz"
  sha256 "0929966802398e6ae3aa2f758952dced11a5a9a36d6b0bdeaa08264c64f2efce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63700951dfc03eefa97ef763d8340e0c6dd8c30b6faddb26979896311befc6f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1214dab575d92349bb436ffef2844019eda5eea3ec79570290b050c88111aab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aed874a8f18ad4c494e3039c9c62d95f1e61442d1413c4421be6a20fa6f3e00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "da42d7a7990211147fb7776bf86c3eb88d07862657ccb6fa8fdb6302b63a9be9"
    sha256 cellar: :any,                 arm64_linux:   "7b7fd215cde7c59e6c8bbd00f33a603ff7c65c033018a6dfb1c6672dc7d3fbbb"
    sha256 cellar: :any,                 x86_64_linux:  "0922d6a03cc49f6aab73e1116fefe1e55a9720d44b2bd328ca09cce732ceb79a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
