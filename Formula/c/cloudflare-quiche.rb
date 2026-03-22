class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.26.1",
      revision: "445292f46e05b72d56b9b957da77bfac3d24fc77"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca8968b996a55e96b74b46a113faab89750e7df04ae765508358511e81b7b3c8"
    sha256 cellar: :any,                 arm64_sequoia: "79a446ec7a4560e3301e1251736370849de911ccf7f29799b250c5f6c36d4e69"
    sha256 cellar: :any,                 arm64_sonoma:  "9c2f55550eccdbbd89b826355e8f473adc43479ca23445ccbcedce34d1c4d839"
    sha256 cellar: :any,                 sonoma:        "86c3b9db3c51b27fbbbc1e56f31d40fcf56e2dddf4d4cdf5e93b870433bc857b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370c6c86ea463fb456adae976bbd04ca0653231c6d9d926b476f91a50e864a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b0bfdafe47603b38c6040099ec3a2573265f388cb2625702162cb2d12e8e82"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    full_versioned_dylib = shared_library("libquiche", version.major_minor_patch.to_s)
    lib.install "target/release/#{shared_library("libquiche")}" => full_versioned_dylib
    lib.install_symlink full_versioned_dylib => shared_library("libquiche")
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major.to_s)
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major_minor.to_s)

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
    assert_match "your browser used <strong>HTTP/3</strong>",
                 shell_output("#{bin}/quiche-client https://cloudflare-quic.com/")
    (testpath/"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
