class AescryptPacketizer < Formula
  desc "Encrypt and decrypt using 256-bit AES encryption"
  homepage "https://www.aescrypt.com"
  url "https://www.aescrypt.com/download/v3/linux/aescrypt-3.16.tgz"
  sha256 "e2e192d0b45eab9748efe59e97b656cc55f1faeb595a2f77ab84d44b0ec084d2"

  livecheck do
    url "https://www.aescrypt.com/download/"
    regex(%r{href=.*?/linux/aescrypt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b40247d58019bfa5346f2cf07d75dbe765f64d9fea747c088f0ac1d44555fe7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823e51604fff46f1cb74a791f7a94c35092393352861fee84c9e5517df795395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3803d5d2dc8c254d7f68d95175e77dc62c5f4a0a6ee01d24e2a7c8a45049e33b"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec24729c18720223c80a584f59f4603c8caa72e23c30c52462e2a7777cc9410"
    sha256 cellar: :any_skip_relocation, monterey:       "3e96703d06fcb1ac6114af1929f87cba2c6d04cb65f2d44aa4f51b56d28c04ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ded6050675d0f771f473d5873bf897d0391859c9f9280362444f2189661ac3b"
    sha256 cellar: :any_skip_relocation, catalina:       "d129279cb28702f27173f99338f5ffd08f042202f5cc3bf2fd71f9107155cc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eddb8372fd630b7f93288f2fb19c3ec96a061b1de150918bee53d0a7a1d55ee"
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
