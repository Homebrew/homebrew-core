class Fastfec < Formula
  desc "Extremely fast FEC filing parser written in C"
  homepage "https://github.com/washingtonpost/FastFEC"
  url "https://github.com/washingtonpost/FastFEC/archive/refs/tags/0.1.9.tar.gz"
  sha256 "1f6611b76c54005580d937cbac75b57783a33aa18eb32e4906ae919f6a1f0c0e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "319e719a3319eb0743f3c2f4bad9982f856d61ad6e48a12834b18d0824f43db2"
    sha256 cellar: :any, arm64_big_sur:  "ebd69d8e9df72f65268e5edf6df685edbebf9c23efe92460fc991b156719c6fd"
    sha256 cellar: :any, monterey:       "d4419d3e30e3b37fd68efeb77714b96ceac2272681208f6642cb93cccdf1a9f5"
    sha256 cellar: :any, big_sur:        "2077568c25d019f94010d2ffd52d59bfbc99426bd46a40ac790f453325cbf51e"
    sha256 cellar: :any, catalina:       "00b9052385c892e80ca899d30f20fc5884b9987b59566fc68512709b41107735"
    sha256               x86_64_linux:   "20a3766b4146a2279677f2510b066b238eef632c7f19e30c9a589deceaaa6f9a"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  depends_on "pcre"

  resource "homebrew-13360" do
    url "https://docquery.fec.gov/dcdev/posted/13360.fec"
    sha256 "b7e86309f26af66e21b28aec7bd0f7844d798b621eefa0f7601805681334e04c"
  end

  # Fix install_name rewriting for bottling.
  # https://github.com/washingtonpost/FastFEC/pull/56
  patch do
    url "https://github.com/washingtonpost/FastFEC/commit/36cf7e84083ac2c6dbd1694107e2c0a3fdc800ae.patch?full_index=1"
    sha256 "d00cc61ea7bd1ab24496265fb8cf203de7451ef6b77a69822becada3f0e14047"
  end

  def install
    system "zig", "build", "-Dvendored-pcre=false"
    bin.install "zig-out/bin/fastfec"
    lib.install "zig-out/lib/#{shared_library("libfastfec")}"
  end

  test do
    testpath.install resource("homebrew-13360")
    system bin/"fastfec", "13360.fec"
    %w[F3XA header SA11A1 SA17 SB23 SB29].each do |name|
      assert_path_exists testpath/"output/13360/#{name}.csv"
    end
  end
end
