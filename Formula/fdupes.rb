class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/2.0.0/fdupes-2.0.0.tar.gz"
  sha256 "eb9e3bd3e722ebb2a272e45a1073f78c60f8989b151c3661421b86b14b203410"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "f23e032f6c62aabb8a3a5935286363f4b5f805a2e9126612c551f6e8bf9c4105" => :catalina
    sha256 "b8729a91b857ff0f5b314350471434dcad1918a1bb6bd555b6fe41cb1a355ab7" => :mojave
    sha256 "44f3f184a04ac478d4b49e25886a50f24853f9ef52058d94f331ee6a71006727" => :high_sierra
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
