class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "b6d400d4add27f52fe6892c22e1d55e59e055349169cef380423c1a810649616"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07336d44e695abd99a30be7352940131ca3f9df4655cf720eac870f6418be38f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409c354bea8e7a35fdd4f1dddcc9f9196f7312116d78dd7796661fa5c62aaf61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bdb5b8e57154c4f40829c037f7cdbeec4e12974a2011be5ea0ef0d10aeb484d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f47e51ec5745aed08415a5f9fbdcdd4961f2c73d52cc07ab6862b74abf50f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "81d11d9c6deacbf61e52314d53253c504f49985f8b35b6e10e41da22fc027622"
    sha256 cellar: :any_skip_relocation, ventura:       "368e530e047e473b885d41efa5a841f93c7586c3b1908ea567d2115b287c2858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76111b6a3585537138c2a8f1f776ddffdb7d578cb433b59767f353d96d74b062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f23cf1521a9f898ba87c54335572b3a3b1e29b88181e57be99404b16427b39aa"
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
