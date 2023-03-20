class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.8.0.tar.gz"
  sha256 "be9273bc0dd3d4bd5d8e5db6a48f2a92611740905c115e080f7f57fd5637041d"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce97a3759786d0edf29628247135588ea2cb1445fd5f243c90da605f2209a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a9e0580e960ca306f2d876b7e170c1daab2553a48778880d6af74792f55647a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6ec8b9d34f2d1c63a926d2c9906ccee68361b255a2107b33045cdfa933be99"
    sha256 cellar: :any_skip_relocation, ventura:        "3da0914deadc0954880553649b844bfba04cf70eae5cddd0bb16686a9dfadad8"
    sha256 cellar: :any_skip_relocation, monterey:       "db79d9fd15c96c205f5e949b5afe70272571be94d6c02d48b9af9ac4f6251143"
    sha256 cellar: :any_skip_relocation, big_sur:        "270f777dc5343399525787cdbe55d49480b0e06f37c2acf2a2f3484ae91a8099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680d17bb901899516a27fb3fbc6ee354be0e3b0f1b3817508c4b18fd2ea192d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
