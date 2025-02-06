class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.17.tar.gz"
  sha256 "b0aed6b4d7f4fa0869857dd5fbc6a55c460fb15b49a03297d74c9f7d21aaf4ae"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf96d9fb4bf78747c24d97c098b91c627dcedb85e0001aabd14338e71a44886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21889b8cb02d88b4719b8c556cdce1b0a311c00e9602d2b61900a5c4986b0517"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3506e02a62175b058271fe2b358b4dc9eeca332406e3946e0e646bff87747d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5273930b35dbf4e2415ff2465491cd272b6f960ea687aee17c878eff8284d86"
    sha256 cellar: :any_skip_relocation, ventura:       "22f83fd7f946f49c6372b89648628aa79ef831072ac8a1bbf9023e0585f19fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6578f77bf9da9824afb7dfcf677fa9e91afb168aa0fc096dfd5ab4df32163510"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin/"neocmakelsp", "format", testpath/"test.cmake"
    system bin/"neocmakelsp", "tree", testpath/"test.cmake"

    version_output = shell_output("#{bin}/neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end
