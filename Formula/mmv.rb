class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://packages.debian.org/unstable/utils/mmv"
  url "https://deb.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  sha256 "0399c027ea1e51fd607266c1e33573866d4db89f64a74be8b4a1d2d1ff1fdeef"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/mmv/"
    regex(/href=.*?mmv[._-]v?(\d+(?:\.\d+)+[a-z]?)\.orig\.t/i)
  end

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

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0f8a80f7b337416d1a63ce453740fbe5bb5d158d/mmv/mmv_1.01b-15.diff"
    sha256 "76f111f119c3e69e5b543276b3c680f453b9b72a0bfc12b4e95fb40770db60c1"
  end

  def install
    system "make", "CC=#{ENV.cc}", "LDFLAGS="

    bin.install "mmv"
    man1.install "mmv.1"

    %w[mcp mad mln].each do |mxx|
      bin.install_symlink "mmv" => mxx
      man1.install_symlink "mmv.1" => "#{mxx}.1"
    end
  end

  test do
    touch testpath/"a"
    touch testpath/"b"
    pipe_output(bin/"mmv", "a b\nb c\n")
    refute_predicate testpath/"a", :exist?
    assert_predicate testpath/"c", :exist?
  end
end
