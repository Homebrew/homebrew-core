class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "a7f9770236a3c66cb06d932d976ac2b30dfa55a1858d1cb93ed3269d9fe9a047" => :big_sur
    sha256 "882a6fe7b736bdb095c380cf7e29ac0d04e28b33cd53370e20a8bcba5809cbac" => :catalina
    sha256 "322d17fd4e60ea24938ec4e58da27940688cadb072eb488818cfec58271afb11" => :mojave
  end

  depends_on "mbedtls"

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
