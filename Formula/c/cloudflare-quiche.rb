class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.21.0",
      revision: "1780aeceb686c212afdd2732b8a568cf5193f035"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cb7c93a5ea77b90d833f0dd2cf8c2a6d7ed2852042804a9f9eb11af99b46875"
    sha256 cellar: :any,                 arm64_ventura:  "81bfc154681beb1abc1e126ac1a0726c7c32bc3695bdb5911a35ad811ebf68bb"
    sha256 cellar: :any,                 arm64_monterey: "6ea012417846fce02c96c7748a1de234f0da0746741b1216b894de9a063b7fc7"
    sha256 cellar: :any,                 sonoma:         "706e51d242ed1da068415b1b2dd93b3ec23b94262da2e2ff118883a1d93cd2dc"
    sha256 cellar: :any,                 ventura:        "668560ee38dba1037455c01386d29045e64e38de9fda49a7025bce892f9416a3"
    sha256 cellar: :any,                 monterey:       "775274cb07f139ea570708fa29b0e1c62756a86b963f1ae7cf91d882e0d8b472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e1abdcae5a0dd4b75cde19f4cbf1e0b643809e24813e249d483bce2b953443"
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
