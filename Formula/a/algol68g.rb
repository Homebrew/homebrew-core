class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.3.tar.gz"
  sha256 "e2eff84682cb0c705a8c1c8561e467592b40c8239265cf49103b44d15d8e88e6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "620ff64ca590c3600da79baa2690cbe8dbc6a9cf1d30aefe49510063c2dd0d02"
    sha256 arm64_sonoma:  "8c3fb4e68523a369f25c2cbfc355d59fb2d91e86e896f5466366a82aa89d9bf7"
    sha256 arm64_ventura: "9edee3706e544f1b7b891b4e8f344aec386a54d40c0c6f1e5cc9ed352a152932"
    sha256 sonoma:        "9e64742227d23e0cfdaa6884f9cf4652d154d06311ba180e705e94c2de21f07b"
    sha256 ventura:       "f8ec064e494c6c95398f66174c44ec00702a2c4cf3d89b7c0148052958eaba94"
    sha256 arm64_linux:   "4f7cdf665f3bae2ea4c2ef15943c6c9f08b223c900b08eafaa87cba1699b6985"
    sha256 x86_64_linux:  "375d621eccdf8d7e0d5b3859bdaec4efce52e4b316f9b592762f93ccd1af7bde"
  end

  uses_from_macos "ncurses"

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
