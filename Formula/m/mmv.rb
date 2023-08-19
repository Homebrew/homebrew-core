class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.5.1/mmv-2.5.1.tar.gz"
  sha256 "f7b4cbd3b778909541df3ab11284288eeb05c68d5ad620f354568e82553dec14"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcd16fe7537000cf4fdf25a0cca6619863b6e7ff7a0851ebddf910a4ce7d9b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05632ba15c14846978cdb96105031efb3cf64bd49f1ba8c8ccd5f06edf2c3e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd8416e6082a478ca9e0b8f9e8d362a6c6b099c48c400edd4b483cfb8f24a13"
    sha256 cellar: :any_skip_relocation, ventura:        "ca03f571a416fab8ef906eea873838332ae69d4e97e8c4349b89915271b97254"
    sha256 cellar: :any_skip_relocation, monterey:       "0f31cd8ba22cad6f5806250333f0ce885fac184764f2e9e1f05f970880071947"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f980bf248cde5825884a4126c6dffbf9fc8538a12623d607b743a438c8d01b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e401678476327b649450fb13a9c083bd1d2185d0f90a7250cea2678d9291c9ba"
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
