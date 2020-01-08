class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.io/"
  url "https://loop-aes.sourceforge.io/aespipe/aespipe-v2.4f.tar.bz2"
  sha256 "b135e1659f58dc9be5e3c88923cd03d2a936096ab8cd7f2b3af4cb7a844cef96"

  bottle do
    cellar :any_skip_relocation
    sha256 "c96c3f1ba5bcd7672630d7c9d693cb5d9333e3473ecdca6771290a68ac54db2e" => :catalina
    sha256 "f52e6c3afc951ca588522d8073b62300113a30cb6d3927a25de643cc10622d74" => :mojave
    sha256 "00d7cb8240e8e1beb4b8cf701bf38961531df8a9f2d497c4ff5a95747ac3dbae" => :high_sierra
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
