class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "7a7680406c3119848c5c3c2da54d5eca9639f1ec36d47784375f7464a0289b01"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3116e68b434ff1bfa87ee929f14f48dd2ca93b7749062b591f46fe85270fae88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a313fef3a45db1d878000524631bc030771bacf78a529d6fe4fc4b6ea76bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56239024f29f59f1c2ef5780afa85e94d70c43848be281a1cd06c04d1f1e4e53"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5a0737dcd45698e6256fd73e9631e570c9540f890452a138f500aed0dc3112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9082a9440c0006d9180c1917a6c4d3ddf3b0bf7891a633ee5b46a8fbc83d23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3f14d34128562b18fc6b3407c1453e15dc7246c0e054bb8a4e17815b1008b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
