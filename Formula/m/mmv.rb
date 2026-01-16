class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.10/mmv-2.10.tar.gz"
  sha256 "2bbba14c099b512b4a7e9effacec53caa06998069d108a5669ff424ffc879d03"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9393ab6a8fa37ce23cc3ad7b991a01d6d3a81bb84a3cf5f4ae6e8aee4d4ee67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b250b77db698b27f905bb70f9a51d543eebcb46473ef3e45cf1633ac5a1e218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dffb0decf330e154afb5051a9120c158daa722d8526c1262b5983fd80378bda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223ee17e0352fb0555d0de4f10a3f41ccc32557ea1b4391f5179772adaf86fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7124ecddb8f17257dd6014e7b24b450237f01626dda1cf5e7523e67004f61418"
    sha256 cellar: :any_skip_relocation, ventura:       "5db972a05a287b8d0f50be04ef2ebf6dcfef37e5553b56a4d29d4b84292e8197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dcde0c3b0f9468bb0768250c4ceb47a63bc8ff2b9ffefc27a01cf01a947bbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb72ba0164ea3fb58177cc5a9ee2470c1614913a78e86ed91fa3026e36f861c3"
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
