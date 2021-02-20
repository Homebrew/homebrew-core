class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.6.2.tar.xz"
  sha256 "bc4479aa8422ab07643df6a1fa5a19e4bed4badfd41ca77e081628620d1e1990"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "94878396eac80e5b9ebb17d31611329bf2ae96c2f7b5c303a289e8a78b97858a"
    sha256 cellar: :any, big_sur:       "331296e946c397f6f94caa8520d7c2a91d4bd5e06996d729f279011eed7a699a"
    sha256 cellar: :any, catalina:      "78373c5516fdadee736e360c5e94a80ca3e3092ab9ca44fd88f31c2a08f8fc5a"
    sha256 cellar: :any, mojave:        "a1c46ddc10694208aae53738cd9927674e076b805180149a1104b4a04bdc19b0"
    sha256 cellar: :any, high_sierra:   "74faf2d3e6539e847538cfbd9f7a86abacb7272d83cfa1d36094f9295f66727f"
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
