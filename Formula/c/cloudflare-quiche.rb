class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.24.8",
      revision: "c9d3e85f0f2acda30acbe186033bf534faeba7f3"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba78563fafdaf69338396b4734533541ec95a4e9c36cead1d287791fc201c856"
    sha256 cellar: :any,                 arm64_sequoia: "c92ce4617bdd0ff59d27e49f6a1d737f61970a89519ef8ee365e3db2a12859c0"
    sha256 cellar: :any,                 arm64_sonoma:  "e7028455aeb569bd24049fa7ace630ee7b43895277287eccaffaa749b9ce5103"
    sha256 cellar: :any,                 sonoma:        "1b5aa7ccc0b2d5896b66b9a74f9b4998aafb305f8ded6196639c9f1a82f11185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c5f7fc2fc291253b0cd5d2cd6a3cf5a82195d881b3d03e29bce4cf3ea7f84c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45ea376a784323b0bd7ee2e67e2be69b645e71cf0564b8b00853cf34e3ce5cc"
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
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
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
