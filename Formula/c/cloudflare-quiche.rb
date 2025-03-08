class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.23.4",
      revision: "68c296009f87a10e1cb935c5879e53bcc412d00c"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afddeaf5d2089ad484a744f23271313b5eed852cb3af9c335e3b99e49c037dd6"
    sha256 cellar: :any,                 arm64_sonoma:  "c4c73ba89bcee679f997182979cd184b8c3b1361d3b9424cccc353c09fbb12d2"
    sha256 cellar: :any,                 arm64_ventura: "11b9d81731f8116ce8631b011c19733533e8baea9029c666b8b02a617a9bee37"
    sha256 cellar: :any,                 sonoma:        "cd267945270cb89a76abb0e4f5083d57da92d6d9b3ae490d34597df9acd10765"
    sha256 cellar: :any,                 ventura:       "c85bdae28fa4379dabebcdbc7951e642afd4a728abeba559827c67c356a64e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d72eb72fbfea5ca1fcdf86cd89b2fe487e93d80bd575ac9902d27e2b40cf636"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "-j", "1", "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    lib.install "target/release/#{shared_library("libquiche")}"
    if OS.mac?
      mv "#{lib}/libquiche.dylib", "#{lib}/libquiche.#{version.major_minor_patch}.dylib"
      lib.install_symlink "#{lib}/libquiche.#{version.major_minor_patch}.dylib" => "#{lib}/libquiche.dylib"
    else
      mv "#{lib}/libquiche.so", "#{lib}/libquiche.so.#{version.major_minor_patch}"
      lib.install_symlink "#{lib}/libquiche.so.#{version.major_minor_patch}" => "#{lib}/libquiche.so.#{version.major}"
      lib.install_symlink "#{lib}/libquiche.so.#{version.major_minor_patch}" => "#{lib}/libquiche.so"
    end

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
