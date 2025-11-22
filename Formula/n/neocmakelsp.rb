class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "323716e5aebf5487e3d2fe9dfd9451ee730a07ede22439193e6ec225343508fe"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6796e714bd3b04b13d2790bfabc1a09574a8612e4adc6c7c6b58eb5b24a6f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4b963989dce094f2df5c12e58d6284ee960384de12f3e6aebf0be24815191b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9787fcd143132eff5d97745a95eba98531e6aac7da9e5dc5e7e4641964e8d056"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e339b6e20496e3aa7e4b9e4fc71f3567a065ddf6ddc5d19450696961ccda7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d60865897c2ad2c232c5a1057ac25ebf276263c381bbb5da82b39109b29391f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cd778b60181c2f37da6edb1f42be45302a90f664a27fb845a0224a992f9338"
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
