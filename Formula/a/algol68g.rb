class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.2.tar.gz"
  sha256 "6ffb646e13eb3b22a427eae0a59e2ea8bca9fff44de8b53467efe6cdd81ddedd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4822384215b917a6bae2415ea2f3291029021af959ce81dcb557514de76c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1a8c4d08c56f31c6ad3531f07c3916a6e1afdc9cb1a837179f8e4ed63a766b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40205bd7a3790b493da9b29d7fb13c4df5e56a978f0e309bc38bd243915762d4"
    sha256                               ventura:        "ad34db100752bfb5d0490d768fd396c2a7208df2ff405d2a7b100aa76576afc0"
    sha256                               monterey:       "aad67bb4fb348d0f1bf4adb58abce63c1f3920788098c88567b2598ea0d3b082"
    sha256                               big_sur:        "04875df1e0f42449f8c335163c53dc1e1172cbc70db31707f3d35c8a596bd970"
    sha256                               x86_64_linux:   "f6fa1b4c1157a0591ae35b3240f351e5cf4635794be6f932931a128d7b7c4af2"
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
