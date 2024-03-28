class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_14/Gauche-0.9.14.tgz"
  sha256 "02928f8535cf83f23ed6097f1b07b1fdb487a5ad2cb81d8a34d5124d02db3d48"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "fe92c5b0de6d21d096fa0456cdba79b34528c1e8405cf20dbe9d8c600e3200e4"
    sha256 arm64_ventura:  "406542d6e05748b2521e0c39b953b0ac5dce067f9f44a4ba9a1b24dc9df592a9"
    sha256 arm64_monterey: "99caf80d561bca4d7064a689fc029636764fa3241e3d32c5a903ebb7b91c5e9b"
    sha256 sonoma:         "83343e62257a97eade0c710332b5127fbb346794fa0ea04a901bf9b0f92c3fbd"
    sha256 ventura:        "4626fcb7cf265ad415ccfeecc4487628140adef8838e5101d3b553023c37ce2d"
    sha256 monterey:       "d391026d354b14c2f58f2719818d326e1277953924db00602a42ce8b89d1b2ca"
    sha256 x86_64_linux:   "1e0872e05354767fd1caec475859f42ba1fa2fe4196256b2f9fb637de07a9a99"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end
