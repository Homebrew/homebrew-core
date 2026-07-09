class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://github.com/lh3/minibwa/archive/refs/tags/v0.3.tar.gz"
  sha256 "85040b1b25caeee6304616c2bc081c313e0ff1a29006bb0295098b8ae51973de"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9cc62e073f1be14d57233456719015b4c773b03cc49a934a68bf73b79c9d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd87f3497534b7d7e9b69ea2367458788068ef43b1568941917c1e0bc4b1d27b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b32c6e1a27adbe646290325a5d285a2c9d2c0a1aee165f9a36fe8695338a65"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1c08a131fdce4d1dd8ef8bf2bb2a7529025a27768e495d0632df35323c1e18"
    sha256 cellar: :any,                 arm64_linux:   "efb5d89f481c25308a8f5a509f11bbe108083b5319f03588edb9d7482916726a"
    sha256 cellar: :any,                 x86_64_linux:  "3c0d1eaa6199e1ae4b527d3009cc57f8c43e14915450874428d59d928317d053"
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
