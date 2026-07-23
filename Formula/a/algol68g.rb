class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.12.3.tar.gz"
  sha256 "4d2e66f81ca2fb98f88e23ae41b475e7d40445f349b1088636782da320bd22b1"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6d646429496c3e5b8724ea75b3d2476e2545fb6773527f30007b77ab0a438a81"
    sha256 arm64_sequoia: "1b68869771e2f062e1a5b7118eb1b478b4f1a3808f051c86e2911ab3a4e36b6b"
    sha256 arm64_sonoma:  "eafbe049c061e953197a5266950362908b335ac24ebdfbd1592097f6fa75cca2"
    sha256 sonoma:        "aef5d710ae0547e8958c36873339fad074e3d86a1b9f17f94cffc5f31d7956a3"
    sha256 arm64_linux:   "4bd4ab4a94bbad9f4970af6374b687d85c92eb2dc70f864f2394aceb9ed686be"
    sha256 x86_64_linux:  "3413a6d92a9cb21659cb8af64b4cb5abe43d3b7f4ac50bfd3c85bf60c7098702"
  end

  uses_from_macos "curl"
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
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
