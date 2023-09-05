class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.12.tar.gz"
  sha256 "1560e1034f3feacb3f97801822013a9fb8fb4c6a87e38fdfc39e45271ea5b8e2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "533e87ea5d4c2ce76d16e735a775f106805c70d2e947a45578a6ce8f77ee5e14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fe9c9f6e0a6c9555125ea105292b90572ae105b048acaa9607f4b601a669606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7aec16aab92decca17b8e4c89341542bccdf6b6173b633667c4ca51e206bb1b"
    sha256                               ventura:        "d7f49c4c010ee4b98bcaa88102b4cb259ec459f140702050c928372c925c7c69"
    sha256                               monterey:       "e1dce05e6516c3cf8241f7e2e515c542e2fa4d5d3777f57c7a943ceca458b2db"
    sha256                               big_sur:        "f2e30a35e1e7187fab6ef04f783b9443e823f6b6f2c6f7e9f2a946bac95b1c5b"
    sha256                               x86_64_linux:   "364aa86ad4ab526e3c6c965d928221116f5971e74c0f8164fa8950932b076054"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
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
