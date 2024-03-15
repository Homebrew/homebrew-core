class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "b094ac0dd20865a13f2237c007fc366e50929f83ec4fed9938dac5d2da6e864c"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32d1f00d6e9e08a379f358bb432444de13961cf81e097de54aa7443a327ceda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c766ebaf3d7ce81da984ee198b9cd510c0b5a735c454e746107fa1860eb4e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "169cfc81a5bc6ea9fb2260c10139c5be277d3e3b1c96e694417ba87691438aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "afdf9ebe37afd0706f707a2f735d60a8ebf973a00574fe9f77483c12b028faba"
    sha256 cellar: :any_skip_relocation, ventura:        "c037b9f07c68f1e6a9f207afe5bd0339280e47b568962f25e8457b6865e64fa8"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ccee19de0ae4b80f827391e1dfb70469b3f85df79868aaca2879e409443431"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
