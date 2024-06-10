class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.15/fribidi-1.0.15.tar.xz"
  sha256 "0bbc7ff633bfa208ae32d7e369cf5a7d20d5d2557a0b067c9aa98bcbf9967587"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b952c91e6ee4e12897cf70898359a4d60bf232339b3f4977bf37d427327764b2"
    sha256 cellar: :any,                 arm64_ventura:  "89815cfe07145e78cb6f9ac9df621f200d28a9aaf00c8da074d5c8202664e3bc"
    sha256 cellar: :any,                 arm64_monterey: "cb3fb68e4c5c4ad8c007209db9ad7276d52252e849f6596d5348acc4eac54574"
    sha256 cellar: :any,                 sonoma:         "8fe7124ecc6586a136b380d73edf070c9dc16a122127139d2f15247bb9751143"
    sha256 cellar: :any,                 ventura:        "664ed32cf6eb7682b3ff7e86bd4fb3df5f86eb97ebfecf136c6312479c5b15bd"
    sha256 cellar: :any,                 monterey:       "7b5e17ea92b11e12f2d73faf9b61b829b42e95f656a57d9c61333177188d5824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03a729ae535ac53791205a6be4e929e981fbd431c04eb2acb21ef132306629b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
