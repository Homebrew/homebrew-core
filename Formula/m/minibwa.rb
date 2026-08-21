class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://github.com/lh3/minibwa/archive/refs/tags/v0.7.tar.gz"
  sha256 "8a1129bcba045e4af4b6fbf73b3fc6b42208afbab870c774c5f0cd2716d748ae"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3eca6bb22984e2f53701d6a567bc0da1f483471b877c10e3f6ddd8b0cbeadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da3ab5ffbdf523d8fa6db56acff2edd542557c5353e7053c3bfd6b9670cee3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b011253c8c52060e8c54a92f2ea979988d9b681f26203767df6a2060fdd51d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c75d8c6707aac2f754ff8a1d217ecf4cf62948fde8e6272a9cef851abea4579e"
    sha256 cellar: :any,                 arm64_linux:   "a8b132924d38e13b2cc7c31bab25e4a6457b8baeb0d6cfe4d414a7e7b8e73959"
    sha256 cellar: :any,                 x86_64_linux:  "9f3800b0328330637487a5ed08ab8aeeb5f9d767c4f0d5ca73efce6abf5a1715"
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
