class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "dec4619b681ad0ad0a9e7b57c196fcaade2705fb086d1f2bbef13a5d2b33ed43"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff2164bf3c8a8222a5122d67d99af61eac481fececfaef7b51367e6e0caca536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2164bf3c8a8222a5122d67d99af61eac481fececfaef7b51367e6e0caca536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff2164bf3c8a8222a5122d67d99af61eac481fececfaef7b51367e6e0caca536"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa70971e65f4b6c17d88e679c478834c55cc6cfef87e38b1d995ec11500decc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe119dd8abade06f5ceb04ba930c8892e348b464e667eccd5430f064aeb85ec"
    sha256 cellar: :any,                 x86_64_linux:  "cefe93b2d268178474b1711b40a61ed85d7ba2c74df9fe8c4b47e966132dec0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
