class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "803c76b3a19e27341a2ca19d1ae13570ede1d358b6e0e0aa3ce94774f7e91626"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0377959ef22d1d9cdb3096c942509a13d67e2099ae920b177bf4c09069889f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c088613df48459a03671af899ab83b0d79e02578619f23d4fc76745b589ded57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9dcdd63ad4517c037168f65f2d807390bdc57130d18928638e7897ec0f96d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "06fb3ae5e03410f001cf053fcca9b4e0bc82774a83e193bce97cd2c06e13568f"
    sha256 cellar: :any_skip_relocation, ventura:       "1a9a0f5d528167cfe3f475acd3b8196860667dc9719b4aac9a68ab52d4fb1bba"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    (testpath/"test.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" />
      </svg>
    EOS

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_path_exists testpath/"Icon\r"
  end
end
