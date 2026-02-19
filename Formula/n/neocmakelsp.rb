class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "084f4e8605e0834c3ca85abd7460801dc22454f45f68557340d02642a4be3c72"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2afe8752916aca756af224086167a1061dbfcac57a687f3efe550bb7b9859a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44678992f4e1b602e5e06ee6753579aedb3e39a51490a8e5bfbc438a51bd856c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ec9ee248477c09088fe9f87e028ccdb034111cc451bc26b75e905866e34a76"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a96e372c15c036bf15d45c64158fdd497e64112f996394b20af3f26725be94d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5564bff0ebd47b024a17049bda7457854772f664e9aea42c5fdc719a638b902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f11802847f41311ac23d32b2b25b860da1a03a601d259983cdc2f0b77bbb86d"
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
