class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.12.2.tar.gz"
  sha256 "455779a7b4c6fee3be6521b24236ffe6aa667986482ff6bb00732797d8dd0bd5"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcdc08433b36e975e26ccbfe02bfe2c137df89f32a069e7b3d1524c16da3f22d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd2b2f306d475322cb9bbd2cae996304053eae7fa5ee189c2e8b94885327203"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7eb34b52d373083c0e99039b54abc204ab9d7a0380f264fdb3fe38fc6b09274"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c0fbb52452ad6c6cd73d85590d4299f8e8b5ab001a22abed9718b826d281851"
    sha256 cellar: :any_skip_relocation, ventura:        "17a6152b1079d7ad6b2c8ebb401faaaafc83ece17d33f19c4b864f11a150bc9a"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0b47481766470c5ea568ddb86e3c773098055a41a00db59126c377e29d8c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff92ba295612b8fa7082e2e9e7441f9371506080e4f11aeb7977d872f17cd4f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
