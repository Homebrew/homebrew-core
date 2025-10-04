class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "55719618f111911cc9ff00bed5c7b080bdffabeb4233faf8812e83c4d08ee6da"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "822a22ba71b1b3cee05b904290c5092aeb78c5e84285e18589f1ea6fd3e89349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb162f022c63f777b8ba5af9cd2c54e09fe2f3f8e5482aba299a0704dc87282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e2c804380323e6c4cc17909f24f8c266c822323557f9e7b8b0be57f93b33be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace2380563073b376d18b1a704879d29b33fcb6d01db60c4fc9fbed35aa6ca0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ea994ab644395293b923ad8fa01c4e809c0e8b940a383d633909672fd64d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d81617cf5126a4ef46148bdfa19e584cb1bc1a3f9a2a8a0140f69d17e6776b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
