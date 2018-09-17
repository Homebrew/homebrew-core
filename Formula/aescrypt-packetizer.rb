class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.13.tgz"
  sha256 "87cd6f6e15828a93637aa44f6ee4f01bea372ccd02ecf1702903f655fbd139a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "03d6532e4d6856942f7b0e85911562b6aed526e5c62ff2a7f58da0f08a3f1d50" => :mojave
    sha256 "3b56b56d73a88af9e76128855d95ef3bd14146d8272fabfdcdc055ba07c97508" => :high_sierra
    sha256 "c4505a05fa4145375adf5d5494a125e72efb090546ee967007a24a71a19fa3ea" => :sierra
    sha256 "56a0020ab5bfb1a14ce0d941f217293a34ca8afbd3f8f83fe5f2aebfa21f5a21" => :el_capitan
    sha256 "a04970668eed3e282d3d37a9b1fe4c4f73f3eb72732092f93a4897ed7dbe7336" => :yosemite
  end

  head do
    url "https://github.com/paulej/AESCrypt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-default-names", "Build with the binaries named as expected upstream"

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
        # https://www.aescrypt.com/mac_aes_crypt.html
        inreplace "Makefile", "#LIBS=-liconv", "LIBS=-liconv"
        system "make"

        bin.install "aescrypt"
        bin.install "aescrypt_keygen"
      end
      man1.install "man/aescrypt.1"
    end

    # To prevent conflict with our other aescrypt, rename the binaries.
    if build.without? "default-names"
      mv "#{bin}/aescrypt", "#{bin}/paescrypt"
      mv "#{bin}/aescrypt_keygen", "#{bin}/paescrypt_keygen"
    end
  end

  def caveats
    s = ""

    if build.without? "default-names"
      s += <<~EOS
        To avoid conflicting with our other AESCrypt package the binaries
        have been renamed paescrypt and paescrypt_keygen.
      EOS
    end

    s
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
