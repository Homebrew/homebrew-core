class Construct < Formula
  desc "Terminal-native agentic development environment"
  homepage "https://github.com/construct-worlds/construct"
  url "https://github.com/construct-worlds/construct/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "b520b05365e4570ebeb5c3f4f536f45596d8f5e0d7acba2e7eba19748553bb6e"
  license "MIT"
  head "https://github.com/construct-worlds/construct.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/construct --version")
  end
end
