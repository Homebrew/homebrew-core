class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.15.tgz"
  sha256 "263c0abd1da22d8cffd181a2d99c6d90410e5c2c6deeb1d6286f01b08a2f6763"

  livecheck do
    url "https://www.aescrypt.com/download/"
    regex(%r{href=.*?/linux/aescrypt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b442496a0e28351481eeab21d287fdddcc417678d3324cc504b0877a0b8703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd8cfede21bcd86dbc5f3d6daa1dcc8388e90c63908717c4229f3bee138a25e6"
    sha256 cellar: :any_skip_relocation, monterey:       "eccc27387b7f6dca75067c976b0bebbaa9306000613c3b31d926d746085eaf77"
    sha256 cellar: :any_skip_relocation, big_sur:        "e70a5b340fb34d4d6619abd8ad18e92ff20f0424b8a6807d19dd8efed5abab04"
    sha256 cellar: :any_skip_relocation, catalina:       "457939887ed6ea960166c2190287603beef6182d92544d9ee60c15e11cb5d487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb98dc9a63f2c2d73588d79d7ad185e6c34a616e18c617de531cf4dbecacf92"
  end

  head do
    url "https://github.com/paulej/AESCrypt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on xcode: :build

  def install
    if build.head?
      cd "linux"
      system "autoreconf", "-ivf"

      args = %W[
        prefix=#{prefix}
        --disable-gui
      ]
      args << "--enable-iconv" if OS.mac?

      system "./configure", *args
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
