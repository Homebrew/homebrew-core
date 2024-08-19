class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "c2708c2f56c0617381fd3a6c61598c4377e2bb5a2fa6bde7b8c91192dfe5c69e"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "963ac674380743de92224956bd8df77eba54a4051c0988fd4a126c762734559a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d8e7d06e45867a65ab932ebc32a8cfcfd2c6d7039e94c516216b89ccf15498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739e485e979a17591a730f17e2dcc43ded0bff8320d7684166a3a5e2be2fa2b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "80341a9092c28796686a48c09980d12792e1aa36dfa9f4e07d94cff690d6c196"
    sha256 cellar: :any_skip_relocation, ventura:        "015f0b83fc4e62a653c0b90a6bb09c48fd74b768e2a225cce6198690a17f28c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c47fa85367b79dfe2e0ddbeab07e941a65d674c948fc9f336afb3ba7a7aa4463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57d50fb6be3388c9a92cd47c211c621e77bb4c8a813511b83a8e6528499a637"
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
