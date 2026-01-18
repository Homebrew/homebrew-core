class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "e3369930e42967d661eca3ac97990f01bac04bd72fb198d954911f995f0220a5"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4862922f59af7d4ea36d088b722a28fa5b18fc064626285ac2aba4bd17d72412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51cd6574a2b0c6923762c7604fd79c1c1eabd4a6eac9d58b4625fb33b5ccdf79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "173550773febdaf8dc1ab9a3d9e71d49dda1b61a61b6ab5b228526279eb0209a"
    sha256 cellar: :any_skip_relocation, sonoma:        "509f1783bbf33fdcd78026fbdb2c2a7f69ca51765f7997aad5560590596d634a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5b1cf722126ff7e12927e4e479083807942bd5604434493da241e0d8a3b2316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af714fd3572b5a911688c5e698418310f2904243bffb3440dabb3dac911b81ba"
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
