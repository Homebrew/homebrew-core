class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.9.1/mmv-2.9.1.tar.gz"
  sha256 "7d18332e62a3ffb021121bd1bbad1e93183f36318206899bdf909a473275f3d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce45354bb8683b8ddcf8fc998838fe0e79515924bbf0c0227d82ceb84e977a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50029e093c2444b882b307849b70aaa2519cb028722bbc1387a3430855b8380b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "842357238ff76a7d18ea045ec3e45cfb937e39de8a4fa9e1916373c948e13488"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed255418e3d7880d2b9f6f8b2b00fde29550f62c7f6a8686b0eba5004b39a35"
    sha256 cellar: :any_skip_relocation, ventura:       "c5f3011b88c439ffe1590316552650288a69ecc0c8b42529649705851e2f5df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aeb6754162fe83dd44ad8fc00eef3a0f21c4e345982e82c00340b952f313485"
  end

  depends_on "help2man" => :build # for patch
  depends_on "pkgconf" => :build
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
    assert_path_exists testpath/"a"
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_path_exists testpath/"a"
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_path_exists testpath/"b"
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end
