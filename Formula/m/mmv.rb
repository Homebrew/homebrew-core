class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.8/mmv-2.8.tar.gz"
  sha256 "d84ce6ebaff6951818ff2fde578c82e35d421d1b35a9d9d21054fcd7254ab7c8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946dc64d2eb0ec61329048b029c67781bb12a1cec8610dfd959929e6f960bce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc9fd805dd7e6a08ed462163fece17d70dab82a4484174dc5dc5c518c5fa96b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ee23afc9b682f8320ef723978cec0685da449ada2217ac606cbb19ee1c44ccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26202bc40fb3ecbf779beff2f67c6b12aebbe67bce211399541a7a0f61b6723"
    sha256 cellar: :any_skip_relocation, ventura:       "6155c8f196c71ebe9dda42669d63eb1ca2b253166c8f7177a2a42bf48898e772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5543072d2830c439b2ae7f54154f8b67b65c0276becbae0596edd68969f056"
  end

  depends_on "help2man" => :build # for patch
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"a").write "1"
    (testpath/"b").write "2"

    assert_match "a -> b : old b would have to be deleted", shell_output("#{bin}/mmv -p a b 2>&1", 1)
    assert_predicate testpath/"a", :exist?
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_predicate testpath/"a", :exist?
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_predicate testpath/"b", :exist?
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end
