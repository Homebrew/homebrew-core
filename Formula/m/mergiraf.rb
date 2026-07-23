class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.18.0.tar.gz"
  sha256 "28b5187a1cd201c96aee6732dda9084406ad3001ed93fcff4e9fc3b740dbe471"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec4342e0ab0e3c46e9f07f441c030e1c839761697934063fa2903679754ad0a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ddecf5f73d554ae758911be5b80cb37669c150dda34aa9ad3466cbb3e31e8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098a7ad816a22bea2254cd55bbad195452af0536030a08f1b3aa7efd92ddba23"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f283330c6f904dd00a352d7091651e9257c2c691998f8a6b7b3d06b58d7936"
    sha256 cellar: :any,                 arm64_linux:   "fc481de5e7c07df01b74386b789d27676b8dc28728da4d70ec549a9636cd1f08"
    sha256 cellar: :any,                 x86_64_linux:  "b5feed3f5e638b05a62a04aafac760fe301d16ef936b23080f7e5daeed275c3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
