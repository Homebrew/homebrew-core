class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.2.tar.gz"
  sha256 "84a891314f7cb1984680786382dc1435222fda23e06f84fe760630e7c2062bc4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ea8debad2e7dd753d37538929411cca2936d8eb4972d442f454b157abd97ddff"
    sha256 arm64_ventura:  "b76e5d8ec6e738eccaf17ff9ce6ab568de3a898c19022ad66d7ab1f1b7d75cb4"
    sha256 arm64_monterey: "88bd7b6ef256a41effd34290f81f55c48b4fc49419b1ada76e1f6887677ed679"
    sha256 sonoma:         "fff2568f5eabc49b1f0daba537e2d31baef23134e6fb25b798f7d8c800c7df1b"
    sha256 ventura:        "b32da523d841337686c6b7bad76bb52d9c5f587bac7a66e7b2c60e9cfbf9fc45"
    sha256 monterey:       "f7d4dca06dcc68fece356b0afc252c7960222b51abde05e4db8905aefbdca721"
    sha256 x86_64_linux:   "173ea98bd790e3097ee6e6589a1cb82f8ed24455dd15b8be3ea16c80a7c5f2b1"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
