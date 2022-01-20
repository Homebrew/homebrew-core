class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.6.4.tar.gz"
  sha256 "1bcc1bdbfdb206f44de75662ee5a8a8c61d336c04cb62457e02c9fa8456f3928"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2f48383c782e29fec795109736994263b2fa13a833e7b06f0d4aec059b94dd4"
    sha256 cellar: :any,                 arm64_big_sur:  "90435bb91b3eca7563d170280fbeec00d63b327944d801df9b01c2fa8d69905c"
    sha256 cellar: :any,                 monterey:       "8d9ce7d5f4b1eff1c1179b57ffcf9dd2ebfc6e4e4dc3d8beb731bd842524c390"
    sha256 cellar: :any,                 big_sur:        "32dd8049617f50f57d99bf620100adf227ed0291392ec89634a40f4acbeffc0a"
    sha256 cellar: :any,                 catalina:       "08f6564b51434509465b7fe9efe7f8ef30b9eeadd0827f1e9ae194c510e40f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a2179f6750dbd3140cc799f78076bd182c9083ec82ef5f1967c6f72f68a7fe"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "gcc"
  end

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
