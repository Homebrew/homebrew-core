class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "99420a3c340ec5665df625f398d6ebb5e4ab5f10c4b1d7c937f8e1e646ed27c6"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf928fb13b47e0d0f7ab4c7f4d08bfca069f689cd64d8d71b511fbed286b1fce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9354d6db67d07b05d3482d5863b549a7388f10cd86cb399ded7e7bcf4e045e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3f8464500ffe7b88c6cc431472e8a45313ab60383f04ff300710a7e9c6f578b"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e0e3cd53c26846cff9b2e023823c7a48affa8df9204759fca18634f882131a"
    sha256 cellar: :any,                 arm64_linux:   "971d34d6b367946d6444909e4a35e3540ab60d06b524dc37df5f037fc57105cb"
    sha256 cellar: :any,                 x86_64_linux:  "01f6203e299311a7a438044a17c384ae7697a926bfd5a59a95a7b5e7d65887b4"
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
