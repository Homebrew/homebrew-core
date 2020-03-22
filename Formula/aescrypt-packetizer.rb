class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.14.tgz"
  sha256 "5051394529bf3f99c42b57f755b2269e6abaae8b0e3fd90869c4b0bb58f5f1c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1615637765b9c2c4aa26bb5c858962d2b5614d7098aa45ebb8154c839fcde13a" => :catalina
    sha256 "063038d7a6789ce5052fa1f7bf1be43ab9cd5c4157d5f9d1d37a91382b007958" => :mojave
    sha256 "ad36c0bff9d673c364b18795669f51329d8e7c5ea862af2ef3614051976cf601" => :high_sierra
    sha256 "39463bd2c693eaa4060f10e8d663346189ff1ebcc9bfa20971158e9e265b7b1c" => :sierra
  end

  head do
    url "https://github.com/paulej/AESCrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :xcode => :build

  def install
    if build.head?
      cd "linux"
      system "autoreconf", "-ivf"
      system "./configure", "prefix=#{prefix}", "--enable-iconv",
              "--disable-gui"
      system "make", "install"
    else
      cd "src" do
        system "make"

        bin.install "aescrypt"
        bin.install "aescrypt_keygen"
      end
      man1.install "man/aescrypt.1"
    end

    # To prevent conflict with our other aescrypt, rename the binaries.
    mv "#{bin}/aescrypt", "#{bin}/paescrypt"
    mv "#{bin}/aescrypt_keygen", "#{bin}/paescrypt_keygen"
  end

  def caveats
    <<~EOS
      To avoid conflicting with our other AESCrypt package the binaries
      have been renamed paescrypt and paescrypt_keygen.
    EOS
  end

  test do
    path = testpath/"secret.txt"
    original_contents = "What grows when it eats, but dies when it drinks?"
    path.write original_contents

    system bin/"paescrypt", "-e", "-p", "fire", path
    assert_predicate testpath/"#{path}.aes", :exist?

    system bin/"paescrypt", "-d", "-p", "fire", "#{path}.aes"
    assert_equal original_contents, path.read
  end
end
