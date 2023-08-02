class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.8.3.tar.gz"
  sha256 "449640052b8fb45f3626a8d906771ee8d744a2359cfb1cbdb94ea89b414cc944"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5911c3006a7ae500c9223956cc7f05ba46b146a5e0f77257d2b6a4c9319ce23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d4aeb5742ebb769815ae62b0458dc4ef3d10421f06adafc7de3de5663f9895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ccd1cad87bdde9d7d2ae72a002cd0c3c0b1c5612783cc21f85733ecfa529161"
    sha256 cellar: :any_skip_relocation, ventura:        "f4c778d556a46d92e189c61c2ce589695bf5d6ec1d7a0e33ae3a05d17bad29ea"
    sha256 cellar: :any_skip_relocation, monterey:       "7825261c38ce8f38d6f7fdaea27cbd89d5f6348a4a73904e45bbc15a3ff7da14"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed165c3c0674e4998309307509bd2450ad09ba5d83cd52a130850f527ba43b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29a665ada7227f97a84515d283602534b43738f77d8922d7259fefe8b3475200"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
