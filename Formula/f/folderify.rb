class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "b094ac0dd20865a13f2237c007fc366e50929f83ec4fed9938dac5d2da6e864c"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58de86e1189786ea95047828af32a2b307ef7c3f53016a6f1b1cb2c383587abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "982203cac8bb3824913a696c873ea4f273b9373318b5399e4ccbbf883a596a90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24fc56f57e1e4c2aea620327565bb263883f362b74efe26a31bd155a15ef212"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b19d04248bb5dcac92e6d6ccbb0eedb33c342208a5973691702679a23874535"
    sha256 cellar: :any_skip_relocation, ventura:        "d23ba3841b84f45a8bcca2d227e598d404ccecd1bd7adfc4525152cb11d267be"
    sha256 cellar: :any_skip_relocation, monterey:       "8af67c9878434070435163bd2261f132428621e7b5d0f86de8d3f30dfe45d611"
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
