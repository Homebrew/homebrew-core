class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/2.0.0/fdupes-2.0.0.tar.gz"
  sha256 "eb9e3bd3e722ebb2a272e45a1073f78c60f8989b151c3661421b86b14b203410"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "461c8de0f269c38289159a5b41935a788955bff38fdc7c104108c9e3dfac22ea" => :catalina
    sha256 "69dcc3c64c3debb7f3b927e16fc6e7e2250c4c35db280a8fd97315fcc48628a4" => :mojave
    sha256 "2ca42f56f5b4e48a4a51cf9687108eb2ebbbf43ce610596d4420be1a68f1ec1b" => :high_sierra
    sha256 "4838e3104ea06e61d7acce5f482ff80bae1d634f29a1edd44e388b9f8c63f19b" => :sierra
    sha256 "b0b7afcd64459cfc3c2bb95ac92e1aa7f6531fbf05603e472c97c5d4e72c94b7" => :el_capitan
    sha256 "ce706b289e019a30c4d07a307ae2c5c10ef1b886e4ee8e5e62f7275a9213a370" => :yosemite
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
