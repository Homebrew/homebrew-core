class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_13/Gauche-0.9.13.tgz"
  sha256 "792fe4e4f800acd7293f9e3095d580a87cea8b221f33707ae37874f8a3f1b76b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "01957631d804616405d76fc8ba28f112254d5681951baf8a9dbe92b247f5ad9c"
    sha256 arm64_ventura:  "df261e44c7642959df6e69f8400ffd4c5beb1437c986bc87d438e2165546c905"
    sha256 arm64_monterey: "b31e5a9df6cbaea3fd35182c7cf44139fc77dd0a018d0fdde13a478379cdf58b"
    sha256 sonoma:         "ad93df603aceca665e8bc4e8ee45286e7c9c5ccd1a0dc070f3d7f5e8799e5d7e"
    sha256 ventura:        "49c692a49a7b0044137d9df07863e7087a4c2c4e87682436801bed673240274c"
    sha256 monterey:       "be2c8499247765f41e57ecdb8ba22c25732be1597c690a345cfbe0e4244e3982"
    sha256 x86_64_linux:   "2745732cdc421c6b45843a12c57d1aab6dd3ec24d8970683fff768ee5204b800"
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
