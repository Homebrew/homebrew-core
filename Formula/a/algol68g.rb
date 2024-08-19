class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.4.tar.gz"
  sha256 "0c04a4f92c36e0d1f2e9155c482f232dadced7a845ecffcea3166ce82f311ec6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "de4e0e3bee14b3b5ac661ea5f9f746165990dd46737fd40694cfdff66b082168"
    sha256 arm64_ventura:  "45ae7eca1fb2bfd62850e3001f8f15c971034142ab89172d3d16ce2950d0dd49"
    sha256 arm64_monterey: "f6f35ee479487fbffc7d9ff7d6d90ce173743e01fc81e63c2f5681abc84e1975"
    sha256 sonoma:         "b1c2281edcf9f0bb62cca7da7ecdc93417a1fe95d7fd4264f949cf55770e5982"
    sha256 ventura:        "49ac8716317b5117c3fea598b5453f59972bebe0537b2ecfaaefa1d76b09e780"
    sha256 monterey:       "6c064990f6a45e4674d64b3aab3d8202005e10dff1335f1c56a3c9c0660c9bdd"
    sha256 x86_64_linux:   "a5fa7d5fc84672ddf2553dc93c6a7410880b23ae64800a0a4b87efd9d48aab78"
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
