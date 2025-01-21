class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "b2071b7ea6779bcfc0fb14d0fdfae002e734f845d62e431df83f30b0f8e2ca67"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499510fcdf43bc734b0ec2e198eb0de90c3d3ea52b03fd1ddcc794ad0bb274ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24dd54ba12d97fe37d06572957a34c3364e9cc1901d2f8d5f7caa4703ab6fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f30ac11cba575dee56d416e781131648f0e8dda53e1e02018bc3d6d51a41c291"
    sha256 cellar: :any_skip_relocation, sonoma:        "317ad3216efa5cebe06f0778f9ce410ff9cac1743c3ded779d12c99b31fb811c"
    sha256 cellar: :any_skip_relocation, ventura:       "281268c777487502fcb6565751ee68245f527d4f43b0051a965e82ad8bb34dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf9b411d21b4ce8df0043cd8e5d3422e2c2e31c0942a4f446e7ae2acc0fecbc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
