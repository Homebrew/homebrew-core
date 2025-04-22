class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b410039c1cbbada80cf010ccfd9450ea6761b0ed5ae9e7fc171b0958bef25089"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3482ee29a22651398ba8e667e47e0a8c931d9c0cc8b4da7c94c4f4a0feca692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4d97dc46bd63d3f253b3f2853ab5d54a330c2b4a12a4c4f919149babe5be06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf31319d879d300c9bd29b2d27c6a71a283540c65f3fee3b7f4f9e88efe1b131"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7ceebccb3b84b01b64f1dc0c4683e80916091be5797e096b668d26c1e87e645"
    sha256 cellar: :any_skip_relocation, ventura:       "57d3578d660ba6ac37612865581f06b9f1de53b4bde0454282ae45597365992c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa79b3ea142d043849c61b62456cfaa916c7e9b60c904f47012f065889afeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8283d5a5b66fe83c9a0e1f9e6c9b30f4dd6056d154c10ef96d09281c65fe1de8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
