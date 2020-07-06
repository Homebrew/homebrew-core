class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/archive/0.11.tar.gz"
  sha256 "e9dc4dbed842e475176ef60531c2805ed37a71c34cc6dc5d1b9ad68d889aeb6b"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "91944c42c39963a6a4c39fa330062ed1d269b0a2be0b5010ae6bac61cff16e53" => :catalina
    sha256 "8a5e731cb4724804c386ffd3218b47a4adb06a86003929d03d24ae8d388c7722" => :mojave
    sha256 "7646ae37a16d2e63594a7ebefb482884f3e60fc7089acb72e0b2aea49659bdf0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  resource "helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
