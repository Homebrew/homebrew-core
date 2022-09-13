class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.7.2.tar.gz"
  sha256 "a686cba9b9874d06ff138249119b796960d30fa06d036ce51df93d8dde6b829f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a463cbefadaf78a7905265527c3e7d808584fcbc28090e7ad610213ead35d1e"
    sha256 cellar: :any,                 arm64_big_sur:  "5fcb8165fe47cbf186644874faa8ba87dc8e0059928b58b0e18d269d195b154c"
    sha256 cellar: :any,                 monterey:       "040e0d7a7820815b7142356658ca6cc421cf94f1810907c3395f13a90ce05fe9"
    sha256 cellar: :any,                 big_sur:        "8ce9802a8ce51ca1913a0abafed5ff93b36e5c67a6f30a63e1cfaa536c834d42"
    sha256 cellar: :any,                 catalina:       "597514a445bf0316d59e7b6855ac255aa3836e86c7c07a3fb76fcc62da4fa3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00c92b1a8ea0098c1b85f0123d1266db01f65e462f94eaec7c53fc5e8f310b7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
