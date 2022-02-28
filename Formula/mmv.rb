class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.3/mmv-2.3.tar.gz"
  sha256 "bb5bd39e4df944143acefb5bf1290929c0c0268154da3345994059e6f9ac503a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25407ec93937c5e868698c5225d5050a1008a0773f8fa73e99b4a60c94290d15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd9be2c2eefa079d30767a2198631bf35394d18b2d518b57f1ea49427266ea26"
    sha256 cellar: :any_skip_relocation, monterey:       "e9b01a309c8c1562e8e5a461a728224a0bf85bd41a8e94e96eced0f473fb7f9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "888b4c1d8edf7aa5a71615d0ff82c6b6c83f349b5e8735beed129c357f24b47e"
    sha256 cellar: :any_skip_relocation, catalina:       "51d7db3a7205fc98d83a432261c2f86bc6992a30716fb8bbcb6c60c571cde00f"
    sha256 cellar: :any_skip_relocation, mojave:         "d754f546b6e586df4ec307e930c6b2e60dd51b0a0929a0240f3b896177909118"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b9076fa267efcabf04184a8ed20d072c1fd33b753ac2f6883495f2f6b4f8a108"
    sha256 cellar: :any_skip_relocation, sierra:         "cce62f0616d060bf803a5bc83d15907a02b90f5ec3faea62422d8fa179982ab2"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e22f894e1224e3c0f85257c5b4db11ed1095b5a2117f48f38653b22a3d395fe4"
    sha256 cellar: :any_skip_relocation, yosemite:       "4e921612e3edb452f6a67f41248247d1c5b60aa22ad17d632cd43e62f5d77084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b1481a85dc9d2e3c10baaa9a873eb4ad049a2685445bf30ea45b045fea2e6a"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
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
