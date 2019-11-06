class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://nixos.org/patchelf.html"
  url "https://nixos.org/releases/patchelf/patchelf-0.10/patchelf-0.10.tar.gz"
  sha256 "b2deabce05c34ce98558c0efb965f209de592197b2c88e930298d740ead09019"

  bottle do
    cellar :any_skip_relocation
    sha256 "a808a7b52e286a6710c079a7e8be08f977554868da6b0fd69032032031900243" => :catalina
    sha256 "8f57b65d6a11bfe332e7663b144c0e4e9842291c2b0a4055bd10794b2911dac4" => :mojave
    sha256 "98e221be1ce346f4c33bee1fc87b7dba33aafcc88c98ac061e04a69c9c9e9584" => :high_sierra
    sha256 "2504614537c2837d9668389349586730c38b93a632175e1cf80568b0650eb5aa" => :sierra
  end

  resource "hellworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("hellworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
