class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https://github.com/Hoverth/fdroidcl"
  url "https://github.com/Hoverth/fdroidcl/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "934881b18ce13a7deb246321678eabd3f81284cae61ff4d18bde6c7c4217584a"
  license "BSD-3-Clause"
  head "https://github.com/Hoverth/fdroidcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eff5d8a8992263ef5309e08d50b18767ec8ce4e4900916161a0b94de35e271d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59042086a507fe60f17c0460f85ac81bc0e9ad650738e0b8c4c12879dcdd5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a59042086a507fe60f17c0460f85ac81bc0e9ad650738e0b8c4c12879dcdd5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59042086a507fe60f17c0460f85ac81bc0e9ad650738e0b8c4c12879dcdd5a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfd91ccb97abe616d4fd3d32ccb498cf79a1787b9700860609de72b4f93c4a5"
    sha256 cellar: :any_skip_relocation, ventura:       "8bfd91ccb97abe616d4fd3d32ccb498cf79a1787b9700860609de72b4f93c4a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7265c44fd957cfe968910913ded8f02f82565194b41b7ebf8d683784ab1b0261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a94907960dcab6c2bcdc0b7e5b6364eb6e221cb52bf3aabb7fbdcc1a5bc93d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "f-droid.org/repo", shell_output("#{bin}/fdroidcl update")

    categories = shell_output("#{bin}/fdroidcl list categories").split("\n")
    %w[Browser Games News Weather].each do |category|
      assert_includes categories, category
    end

    assert_match version.to_s, shell_output("#{bin}/fdroidcl version")
  end
end
