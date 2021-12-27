class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  # pull from git tag to get submodules
  url "https://github.com/helix-editor/helix.git",
      tag:      "v0.5.0",
      revision: "a1b7f003a6ea61b2a77056ce8865a779b3452975"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-term")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx --version 0>&1")
  end
end
