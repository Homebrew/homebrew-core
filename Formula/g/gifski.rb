class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.32.0.tar.gz"
  sha256 "9a9145c31936f6e6e3b30e7feb8a741bcc02e8bcec6fd480d03c25ffa55f372c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b889ed9f65467b0e919d9403c03b784ba9a200459dd6b684bb3526197b35448a"
    sha256 cellar: :any,                 arm64_sonoma:   "7eed39c25338fafdfb6547e305a02f137c10e6624852be3c60dfa36527be35de"
    sha256 cellar: :any,                 arm64_ventura:  "482fba0d44f69d1e5b137051022f2ab2fd83ed61ecee0f34d9e6909a422c9dac"
    sha256 cellar: :any,                 arm64_monterey: "c0e54ca91ce8e920d50461c7bef2432881f9ddc347648f23617c871b1448611a"
    sha256 cellar: :any,                 sonoma:         "106b8f0b03fc6e059aec0d3274f92da8ae33cc0919980d60a36e0b8917046755"
    sha256 cellar: :any,                 ventura:        "e4320c33cbe202bdcab24640377483950c90ee27c47192791300c109f190a8df"
    sha256 cellar: :any,                 monterey:       "f68b1f53e4ee3b59a627f93752461a68f94711e7c8cc68f4fa3e7c0883cf75f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5acc7e25a1311ea15611f213bbe144de06db490c002321bda776eeb0722b22"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@6"

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
