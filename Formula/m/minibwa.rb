class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://github.com/lh3/minibwa/archive/refs/tags/v0.2.tar.gz"
  sha256 "aacb2dabe78874923b1eea6197919c0f75e12de87bdf906fa4adf58a6ab1b25a"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37fb061fb4ee940cc65b28c1eb25e17c1ee6e543b0c9e1f1fe4199649deb034c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae74ab3ead14ac7e4e79cacceb6397b54df086ff181741f66e744eebd565c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2fef3c67f4907a42c75f3cd3d3af8e69705848dda40ec2e711676b38681425"
    sha256 cellar: :any_skip_relocation, sonoma:        "df90a1b244214530d9a9412a67376b8a25c38cbde3ce40ed61c723f9ed254edf"
    sha256 cellar: :any,                 arm64_linux:   "4fa08244c9b50c0b4fed0ebe28a4a2aefb5a85064abf6464c76c4fa9b19a8ec0"
    sha256 cellar: :any,                 x86_64_linux:  "3dbd92838e8e2253b336c9571ed25630646f27ce043b99bdd3868852c12983fb"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "gpl=0"

    bin.install "minibwa"
    man1.install "minibwa.1"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath

    system bin/"minibwa", "index", "chrM-human.fa.gz", "chrM-human"
    assert_path_exists testpath/"chrM-human.l2b"
    assert_path_exists testpath/"chrM-human.mbw"

    output = shell_output("#{bin}/minibwa map chrM-human chrM-read_1.fa.gz chrM-read_2.fa.gz 2>/dev/null")
    assert_match "@SQ\tSN:chrM", output
  end
end
