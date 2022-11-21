class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.io/"
  url "https://loop-aes.sourceforge.io/aespipe/aespipe-v2.4f.tar.bz2"
  sha256 "b135e1659f58dc9be5e3c88923cd03d2a936096ab8cd7f2b3af4cb7a844cef96"

  livecheck do
    url "http://loop-aes.sourceforge.net/aespipe/"
    regex(/href=.*?aespipe[._-]v?(\d+(?:\.\d+)+[a-z])\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b129be891af0e105e708632942b655e614a35c522111872643b287c368aa2d52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67e4984fc6794d5e6c5b973b7faa472d86b1e434d3c4ca8757ce8e7ab7625e4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204ddb0b9c6fde98f4bdec7c3c93aa2ad95cde565dd22538f2c61a55875a398e"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf3f1412a063d7f942ff00de628f119072dc98f9d85d82f70e04815ac2e4ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "3182b08b5f9aa35f3a56e4012da53b569f7e4458e86c0c522957b26daf247e0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b94579255152f8761049784697e757d2399f075bb77b7c194741311aad2943c3"
    sha256 cellar: :any_skip_relocation, catalina:       "c96c3f1ba5bcd7672630d7c9d693cb5d9333e3473ecdca6771290a68ac54db2e"
    sha256 cellar: :any_skip_relocation, mojave:         "f52e6c3afc951ca588522d8073b62300113a30cb6d3927a25de643cc10622d74"
    sha256 cellar: :any_skip_relocation, high_sierra:    "00d7cb8240e8e1beb4b8cf701bf38961531df8a9f2d497c4ff5a95747ac3dbae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7fc1cc1e3cdc08237e3136d528c11c80fdc6c0ded76d812f9d3c141046bc00"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "thisismysecrethomebrewdonttellitplease"
    msg = "Hello this is Homebrew"
    encrypted = pipe_output("#{bin}/aespipe -P secret", msg)
    decrypted = pipe_output("#{bin}/aespipe -P secret -d", encrypted)
    assert_equal msg, decrypted.gsub(/\x0+$/, "")
  end
end
