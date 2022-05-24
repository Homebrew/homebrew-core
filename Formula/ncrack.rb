class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://github.com/nmap/ncrack/archive/0.7.tar.gz"
  sha256 "f3f971cd677c4a0c0668cb369002c581d305050b3b0411e18dd3cb9cc270d14a"
  license "GPL-2.0-only"
  head "https://github.com/nmap/ncrack.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "4238670deb9d89e934602389557dfdecf101b3429a6c95fc527ccdf415bd869f"
    sha256 arm64_big_sur:  "b684949d21ace4bb1f67030b74e5daeb3db83601e4a2e4221e24fabcca0b489a"
    sha256 monterey:       "250e5c5bfa5a64e73628e1e274b01906f0bb4d14c92c658b49e60c008e869051"
    sha256 big_sur:        "025bbf5951382b56c8a6a16b558eed06e13eccc3885eff0080e4c32907176a08"
    sha256 catalina:       "4cde5b8ed210e4b5f2ef644507d4838b367012f3159f649ebe81a375fed66029"
    sha256 mojave:         "907bcfd20459589aa0e7ae766897d38613338e9c1f57244d2610bf8a1b3b1e59"
    sha256 x86_64_linux:   "7e269a772c515bb8dfdd7f000bc8989f4e4609fa7f1aedbffa6176fcc035f761"
  end

  depends_on "openssl@1.1"

  def install
    # Work around configure issues with Xcode 12 (at least in the opensshlib component)
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output(bin/"ncrack --version")
  end
end
