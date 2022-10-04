class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.0.0.tar.gz"
  sha256 "e09380ca54a6669060eb8ee453f2329e74e6049c9fffb80532d83119d1122dff"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d65309fdf73c046d0abf9ec418e1bd3d1ff74f9e8d1d7af6953a0e1fb12014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5898e34fa68727f0adece03cad7e55a36f5e1c46a033cdf34c0132c31c04665b"
    sha256 cellar: :any_skip_relocation, monterey:       "5059be775c75ad2946279054a679786d98d4896c07ea6c6c71faf4a2758d085e"
    sha256 cellar: :any_skip_relocation, big_sur:        "43adc9c3eeff9d5e25eacb42bbe164ca25d58081b98ec075850dd826ac404527"
    sha256 cellar: :any_skip_relocation, catalina:       "6461835f1747e21905c3aad4fb577d048d0ff62110e31ae95bf1d1d6409bcc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e84f219c05525559ec47b6f9c43018ad012cdf112539b08726fe5870f0445e"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
