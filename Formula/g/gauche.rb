class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "c4f061ee978fdfa0397720d8a8d24da45edaca3c03aa6fe06d72968fc265f06e"
    sha256 arm64_ventura:  "4fc0349bf0e551cc17953a33faf24b73aa9c918f85fdb3546f56d0ffef36d382"
    sha256 arm64_monterey: "75edd8aeddf7f499e3376ac5e4999e16a714b1f89457e963a991183b38550588"
    sha256 sonoma:         "531bc327aac767bb15b819cdd5c46fadbc839d096b76a4ff169143a4689a9cce"
    sha256 ventura:        "90321f5426f3d7b270e2ea970344d1029707ea8f23d25b368f50f4204e8328c7"
    sha256 monterey:       "5f530c0aa8df9d97056829a859c1265ef9a0160ef253ae701c6b3ecbfe0313e8"
    sha256 x86_64_linux:   "ef780888f8f24944faa4480c74dc38a827ff39e0e257401718d6886c0b1c3097"
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
