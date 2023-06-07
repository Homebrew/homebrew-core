class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.4/mmv-2.4.tar.gz"
  sha256 "5a328bea0259c9fb7eaaab6e5f4bb1b056daccd30879ff102dc00db482f2f6a1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1262478caade185cead37dfbc6e0249f52c95501790752a73757c93e41566aa"
    sha256 cellar: :any,                 arm64_monterey: "786e4d4823b62488cdce80b7d94c3dfd3c7d5e9db7efd690fc87205626e5e2c5"
    sha256 cellar: :any,                 arm64_big_sur:  "91c68bcd462397cd181ed1ea7dec35552df88dbbe4d2d1e9fa57787b6e0ec3e0"
    sha256 cellar: :any,                 ventura:        "2ade651d8f99d68aad0ec5618aee46758e7e1beda784def52ee6b584a64ca5ef"
    sha256 cellar: :any,                 monterey:       "76655b3ddd9cdf85eb806365da884a031b489a9a7cdc904cd9c24fc270a58566"
    sha256 cellar: :any,                 big_sur:        "33d64ab428b59598d484c1b1f920c0ed218755b308ab24bd4039f0af2cf3fb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875ed3e51126736dfa91b7f3b4e018f3118a844664fe9f84537a5d06edf12c30"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

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
