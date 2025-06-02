class Dpic < Formula
  desc "Implementation of the GNU pic \"little language\""
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic/"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2024.01.01.tar.gz"
  sha256 "a69d8f5937bb400f53dd8188bc91c6f90c5fdb94287715fa2d8222b482288243"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d99f3d68b5d5f6cdd1442f68ea5a9284026d569fc4e6419330631922cfacaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1359cf82e6b9997e0543b51fe66e278c3f00104064c7757fc6d53a6d5da8363c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62e275983e3ad6f36101e0a524a29c9e24d973a72443dd750d44e7dbc6353adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "306191125c20b05c28dae91d0da90c012769e4ecd0aa491e2d78d89594da640a"
    sha256 cellar: :any_skip_relocation, ventura:       "2be8b31cce643e70b5120d3e8db82c2e6e6733138f62c8d960b0544a05682ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3440b146c2ee69950d80a96aee0be6aa37e2d418e1176ea5a63cd2032efc836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bb23d148d753c67dc621b7b5d8b9f3ca8759b7dba0cc45d9fc3b51a7e0611c"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "dpic"
  end

  test do
    (testpath/"test.pic").write <<~EOS
      .PS
      down; box; arrow; ellipse; arrow; circle
      move down
      left; box; arrow; ellipse; arrow; circle
      [ right; box; arrow; circle; arrow down from last circle.s; ellipse ] \
        with .w at (last circle,1st ellipse)
      .PE
    EOS
    system bin/"dpic", "-g", "test.pic"
  end
end
