class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.20.1",
      revision: "dae27b7d5a0dcf8304a56ffd295399fc00ec03e9"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3a831d97257fe5dc8695aabfec5856a7f9495e64b62b1306e2cc767fe6d9e10"
    sha256 cellar: :any,                 arm64_ventura:  "e31a1ed2d9a67b58714a98b394559369b3d1c8719b6bc37957717fe26ccbbe28"
    sha256 cellar: :any,                 arm64_monterey: "c3da869d1828557d7abd5e25fa23b40f1b1e51e7f8d4d958692820d667ea4d90"
    sha256 cellar: :any,                 sonoma:         "89a0c1e2ef3d0112d5209a64165cba6b5e2acb0966fc70160d96cbe56e8e7dc7"
    sha256 cellar: :any,                 ventura:        "2779621ec9d55baaf03d5d7eb45e75fdf6eee21d0b8d250f9354d229e520ac46"
    sha256 cellar: :any,                 monterey:       "2e2a23f0201a3c8ce4fc7946d38a8000c622c815d0c398db3117d7d0643e1f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf7b7d81e0dcb9bc529481a2ed59f087b1c010afc14366da750e003ca1a2739"
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
