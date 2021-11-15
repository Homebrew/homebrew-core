class Aamath < Formula
  desc "Renders mathematical expressions as ASCII art"
  homepage "http://fuse.superglue.se/aamath/"
  url "http://fuse.superglue.se/aamath/aamath-0.3.tar.gz"
  sha256 "9843f4588695e2cd55ce5d8f58921d4f255e0e65ed9569e1dcddf3f68f77b631"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?aamath[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e823e4d89ae67660af61746c7472d80f0eb2ea70503471ac1190f9c0c691faf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eec6c9dd0ae3b32b3d2b22ac4cf926c6b3084a41623361762a4c0a297dc05286"
    sha256 cellar: :any_skip_relocation, monterey:       "58065a231153b1971495d1d07c7d68740a1e7ca51ff95d8c8684ab511aaa4ab7"
    sha256 cellar: :any_skip_relocation, big_sur:        "588a5ccb517b6d41a4f323f7a376cd9a34e4d0d447baf15179c05fbbf2c0e588"
    sha256 cellar: :any_skip_relocation, catalina:       "1ac1413ef0322b280ae5bd5663373ed959ee54d28dbdd3261fc4da6e57abf44c"
    sha256 cellar: :any_skip_relocation, mojave:         "79ef03b1d334136b693131b133944109545b07aca2dfd9165531016e4250444c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "41223cb51bc006abfba33b6af77b665c28de4155d19e5f43d0561b885b73368f"
    sha256 cellar: :any_skip_relocation, sierra:         "d537cb11d2dcbac9b5d5356c471775699312e83450635ba7676083f381a531cd"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8b805e37fd5f4536b4fbf7f3ae6251b645b4b132027d56ccd015a6036c304744"
    sha256 cellar: :any_skip_relocation, yosemite:       "1e22022e621e7d2337edf4a80ae2c1618a89089132656d85cc141774565e34d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f803d33b088e251eba9820706307616a771dea7d2994818a8fc36aca85af0541"
  end

  uses_from_macos "bison" => :build # for yacc
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  # Fix build on clang; patch by Homebrew team
  # https://github.com/Homebrew/homebrew/issues/23872
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aamath/0.3.patch"
    sha256 "9443881d7950ac8d2da217a23ae3f2c936fbd6880f34dceba717f1246d8608f1"
  end

  def install
    ENV.deparallelize
    system "make"

    bin.install "aamath"
    man1.install "aamath.1"
    prefix.install "testcases"
  end

  test do
    s = pipe_output("#{bin}/aamath", (prefix/"testcases").read)
    assert_match "f(x + h) = f(x) + h f'(x)", s
  end
end
