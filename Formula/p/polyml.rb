class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.9.tar.gz"
  sha256 "5aa452a49f2ac0278668772af4ea0b9bf30c93457e60ff7f264c5aec2023c83e"
  license "LGPL-2.1-or-later"
  head "https://github.com/polyml/polyml.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "100f3fb2f2b4afd32f89f55b319742e80513df3b7b46e1824f8cfb5ad458f4c7"
    sha256 arm64_big_sur:  "74ffeccfd43af75e74239336480a4bd9d93ded28e874738b2417bd7c421cdb7d"
    sha256 ventura:        "009fe3cfe15337431d50b97c752aff0336f141e47cf055551901f749edf9a6fd"
    sha256 monterey:       "6cf8429f83e6664dd0c38937b7cba90cc7135a19c5fcdb1a87405edb582aeb4c"
    sha256 big_sur:        "076f53e47fd75365984bcdf860eb21101683f86789651c41266e855a333a0192"
    sha256 catalina:       "36c5f2c6052f27e89cdaeec09d1e7e38603894e3d3a13aa0bddec6ef287085c3"
    sha256 x86_64_linux:   "5ad3750111376bc7bb887cd30ecbb8ae368cf1e06176c8b4293e6a976d6f4590"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}/poly --script hello.ml")
  end
end
