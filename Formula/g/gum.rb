class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "2cbc41662ff6c8df30ff3f6c133d4276db72a6f9b3df7eb942f1a798bcbf3d80"
  license "MIT"
  compatibility_version 1
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a14d2861ff1a4e86b07abedb7e6b5715c39e64c66c9a0d392e6f0871ddfbb6cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a14d2861ff1a4e86b07abedb7e6b5715c39e64c66c9a0d392e6f0871ddfbb6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a14d2861ff1a4e86b07abedb7e6b5715c39e64c66c9a0d392e6f0871ddfbb6cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57ca4d607f804b079dd431837ad85bce1110d80b9f20b6da7b1497004e100f73"
    sha256 cellar: :any,                 x86_64_linux:      "56a727a82cfd54775cfc550634b3c6da4bf4b7001fbc038cf9b9deb5f434961c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
