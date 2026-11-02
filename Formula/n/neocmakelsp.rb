class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4852cb598c984e920c9e3a36dd23804c2515b778c14ebdfc9b8a85407402e569"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "961a9e9b5b845388cb9756fba960ac51c3fa86b80e77d17b87a97032ca36fc76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bc2cb500ba3ac3d237bcae1ce0b30cfad343ff36bd6c60f71b75e9cc9585b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f012bae5cb932655e22581ad5981e6b4bb15f60880ffd86106e64b9198d2c1d2"
    sha256 cellar: :any,                 arm64_linux:       "19d2df917ea97e5202b2411106e2fe91c851053ab1f5bbd52fc71b6c83c857f7"
    sha256 cellar: :any,                 x86_64_linux:      "def8f3c8d57c84cae13ced69a33bde01acad65797f1810c6a345474cbf7f40ff"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"neocmakelsp", shell_parameter_format: :clap)
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
