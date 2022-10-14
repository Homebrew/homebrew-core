class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_monterey: "e8ed3922c71a7893b922e4ae30523d721bb49c9c6b069918662a85b6f718d4c7"
    sha256 arm64_big_sur:  "f6794c8076aca975d4fa65c588b03e4e58cc392fbdc52c1d5dc63539152c8f15"
    sha256 monterey:       "d2b320ef5f8d160bf020b66231d066fcd7474e57b5c0945ce7e9404edd93051b"
    sha256 big_sur:        "51e132054978df068aaa5aa01d25c0005a32ca6d536e454bdf5d9ebbafaab347"
    sha256 catalina:       "8de979e5a97b3bfb9b692b060b5d07b7e9eff3b9f03780c273f7f270ae6742aa"
    sha256 x86_64_linux:   "5a3f90926fd31d7fc2d29e85dd119fa1e65ce7e0033916661d21d533949561ea"
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
