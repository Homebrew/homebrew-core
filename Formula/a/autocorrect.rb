class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b1363155ef4a3e7379a1ac6540389f350955b3ea63e585143cfb539d1f63f8c5"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc9c393239c1a01bd10d2d3842c53d769d320cb0491a63a7c8896bc6622eb182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b7407c0376017ef3880f17743419717e7d5b4bc4954e69502e6e5c03b97c596"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f8cf1ff667a784fc91a3d10afd86b6bbaecc8844d0ff072d501b867b18034c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a43c298b348197a7e3c2f867454336bd370101724dc90cb6305598789a5a4457"
    sha256 cellar: :any_skip_relocation, ventura:       "7f1de8a41a9bf187c51bd8ca3dd01e0d553ee3f981a13460b64028c617b9959d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53e4ff41271e2bceffa43d128df889821b5a488c52c43b6d23dae41d18d4346"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
