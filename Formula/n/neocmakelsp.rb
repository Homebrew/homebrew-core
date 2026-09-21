class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "4d562ace6e26ef2c93bb8cec91e85db1241b6e0990d67d76ae87cff2f422e5a4"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d450320b7f8854301101f5a10adfe7a19ef1c8cb7d0ee1b004f6e141b4faa71c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26082f8db6c2aa8c8b8e7dd4d71de78945c55624c49163e3653713dd2e697d0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03e6ed6d04a6b918825ffac87f835302c89a75e9bde4253aba91f017cc242d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "678c9b882dcf3c29b716c3a8b0234931f606dead0d2c5844880cfd013fa75d6c"
    sha256 cellar: :any,                 arm64_linux:       "8f1b7c9693b939dd126870e112e95a6e024656b651f0546e4c5dc44932a87c74"
    sha256 cellar: :any,                 x86_64_linux:      "b5dd8d9587bfca55a781fbca08245e683ea39d827e1d8a7281cba79dbefc7424"
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
