class GatherStep < Formula
  desc "Local-first code graph for multi-repo workspaces"
  homepage "https://gatherstep.dev"
  url "https://github.com/thedoublejay/gather-step/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "7a084fcd016c81bee30de9750a3b386b6ca2804d1580648fd6f0a9d3eca3acf8"
  license "MIT"
  head "https://github.com/thedoublejay/gather-step.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/gather-step-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gather-step --version")

    system "git", "init"
    system bin/"gather-step", "--workspace", testpath, "--no-banner", "--no-interactive", "init"
    assert_path_exists testpath/"gather-step.config.yaml"
  end
end
