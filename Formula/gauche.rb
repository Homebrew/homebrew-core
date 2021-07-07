class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "86f3f5bd68346eee408d1500bff6782b3d3fff937a96dff80f93022b695acc94"
    sha256 big_sur:       "88d426f92baff2b17011fcf645fab3384bd9057c9bf71ca3976fd68a24c5d865"
    sha256 catalina:      "827634eb03776d2a21ae7a0d90ee0d18c0f4dba034f50149dd4aed4f343bb906"
    sha256 mojave:        "44dac5484933886fc49e0e3e02140c44e6189ae65c7ab32f2f3ad24521740ec8"
  end

  depends_on "mbedtls@2"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
