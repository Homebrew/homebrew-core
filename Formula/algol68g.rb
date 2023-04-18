class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.7.tar.gz"
  sha256 "9871163c9df2d4c64381ba4bc7870efc6093265f6e18bd996ebc398d3c0b2423"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "605ef3bf65f725a6d58b9dc7bc188266db85b8e5732ce248dcd2d9e9410e57a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa2e2d4d79a4597769cfbe970f2d65a09f934f63737c5e636d1128d78ecbe76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cd915992ae42c141b32a40f1e20866261d3a9f507aeb18818618ecef8b2fe32"
    sha256                               ventura:        "e1138bd28dbfc6911a06c788744fa4033dd438c84a502492c1ee32aaedae5414"
    sha256                               monterey:       "dd0c51839b1c03718cbbc1e015fd6d08bdebe9c75a29138aad15108060235895"
    sha256                               big_sur:        "704daa5a7cd246349ddf501156ab8654f78e4ed7d61574c72ac0ebeb7eeb2a21"
    sha256                               x86_64_linux:   "e55717dbb66270f591c4ef72fa86c8f27aa5c5b55d1550afc88da872d98c51e5"
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
