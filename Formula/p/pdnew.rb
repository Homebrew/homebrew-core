class Pdnew < Formula
  desc "CLI tool for creating new projects for Playdate"
  homepage "https://github.com/fnc12/pdnew"
  url "https://github.com/fnc12/pdnew/releases/download/v1.0/pdnew-macos-arm64.zip"
  sha256 "13b2bf79f558e8589dd1b504586698dadcb1035348a86b3110c88002367f99bb"
  license "MIT"

  def install
    bin.install "pdnew"
  end

  test do
    assert_match "missing project name after pdnew\npdnew {project-name} -l|--language c|lua -a|--author {author-name} [-d|--directory {parent-folder-path}] [-b|--bundleId {bundleId}]", shell_output("#{bin}/pdnew")
  end
end
