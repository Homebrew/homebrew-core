class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.7/mmv-2.7.tar.gz"
  sha256 "11346686634000e22aa909e08d9d450237c4b61062779935cbd81df78efad72d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44f737a7861fc7692883eada12e02ecd673d2db2428e912b01e37fd1b5508e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a667fc3965a68ce82e8061940b2a2915cb30590b2302e3bb81f3feb92d9274d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b59c98077002707111ce2e8b490db9be55cdf3e385d2cb75799f83c3a5a4cda1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e002f3bd903786200bcd2798faac24e743c3fad64d8783c8c060fddeb9f630e"
    sha256 cellar: :any_skip_relocation, ventura:        "28cf147b34c926e2128d916c0270f2bb7be13e3811aa7f9e6510b7cb2c6f9018"
    sha256 cellar: :any_skip_relocation, monterey:       "5535a2af0359dcd6e5efe6d37fb7ba3d9d92dcd748ba63104497b9dc64007771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe30b30ee1bff52f9d14a95fbd17d99cb45359677dfaf4ca9ff6051596e4588"
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
