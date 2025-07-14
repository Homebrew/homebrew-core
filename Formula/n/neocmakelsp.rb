class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.23.tar.gz"
  sha256 "3cbc9ce4b49a93a67137af0ebe619c7fa39998376cb5ae75baf53c38211fc6a0"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ec76492d08394e2ac0b9e9c1218fb04ddeba0458684e439d96722976b2f268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ed18336a32de0fd7c75e11c94c8879de84566cd3834affe36d36df72bbf6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1fdd88692bfe1b965f947e6999c9a0df187f6647e84076839afc9e38c2cb90c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a5285ae6cf4bace96c7e248e9e2a1f5f31d38693921085fbf44a2a1aadc8d1"
    sha256 cellar: :any_skip_relocation, ventura:       "c77d083af20b2592a8b4ccd230796568f43748d5a6f4a81e0da0009f6b403ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da000c9f855c537e4d18cfd7fba8af0d65b2f72523f78bce8b8131ab3c66ac1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30294ee5444d3ed26d601323f2d0d53501f1e301078cfaa1532df5f3ed533b0e"
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
