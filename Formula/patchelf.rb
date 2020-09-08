class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/archive/0.12.tar.gz"
  sha256 "3dca33fb862213b3541350e1da262249959595903f559eae0fbc68966e9c3f56"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bca91d5be894ea5ebc1c7b0af93027e7669c460b7f792455470e78e73fc16d52" => :catalina
    sha256 "d4d4b739c36108e8f794b19a76a44efeed42baeeb4f5dcd61002c7ba29105dfd" => :mojave
    sha256 "d7c841a08ca1f9e4cc24fa6378e14f82f46dac6124d860777fb53161ac82a426" => :high_sierra
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
