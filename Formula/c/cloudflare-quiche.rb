class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.20.0",
      revision: "5b1e3d286411e2cc411f8dc6d6ff1ee40f1bd026"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f281f0d96925b21b9bd751a96cfa3fb4d1e5c25325c49251d6ea2fd58f6488b"
    sha256 cellar: :any,                 arm64_ventura:  "02da14a6cacb951eb5a62e37adef6e4c9e2f3a3716a2526f6d7cc9afa11d52f5"
    sha256 cellar: :any,                 arm64_monterey: "398ebcf2aba174360de935d27f7ea3828b86016cddbf41e1631e3f8b4df309d4"
    sha256 cellar: :any,                 sonoma:         "85edce1d91484e8432bd0b93c4003e64b2b8444499a3c62b24c88b3d17889d6f"
    sha256 cellar: :any,                 ventura:        "0efef5015d1a5e1ff00db312e0d69ff5e265d1b305d1654b215ef999de613bd6"
    sha256 cellar: :any,                 monterey:       "44716d9a61c3dc30d6a6348b5a40b8bb1797637c8763a7cde6b0de60ff57d69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37005d35150baf9bcf71cdf1d3d2cdd7e1de45fc631fc18c3b0be69385160c9b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/#{shared_library("libquiche")}"
    include.install "quiche/include/quiche.h"

    # install pkgconfig file
    pc_path = "target/release/quiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(/includedir=.+/, "includedir=#{include}")
      s.gsub!(/libdir=.+/, "libdir=#{lib}")
    end
    (lib/"pkgconfig").install pc_path
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
    (testpath/"test.c").write <<~EOS
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
