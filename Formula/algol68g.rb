class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.3.tar.gz"
  sha256 "660c338c1bf9db123073c7403cc21aa465795a9377754162cbbf8bda97259612"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e3c1b6022f9c95d43ac177889330b2aeab5cc4c75bec0d9c81e6bc3a4e52bad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37748c1160655c380dc27e2b6702f4c1ddf822eeb4efae01218d05b22e82985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d4ba4e02d88e183fb54a96e1702e229b930e603c11fbdd20071c7e4931a0076"
    sha256                               ventura:        "922c5dfa253374741d669ae51d9a525670f1b797ed302520963ad1d8cf76cf7d"
    sha256                               monterey:       "0d3222188e840cdea444f4da1c40fc3737c7dfa8f8463c7b7adc08726224b002"
    sha256                               big_sur:        "7044219f656b07cf34c3e96a429cb51aa6eb5c0e7d86441201c342e350afbda6"
    sha256                               x86_64_linux:   "92de0b7334e0346c309dfa18e2d930e8b58ad111bd3d30a91bcbe25bdfd45f46"
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
