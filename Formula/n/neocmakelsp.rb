class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "55ae5a731fa3b7091dc8474420ba76f61a5228067ce71d69cc0d3fcc5d6f83dd"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af2fd7701ad2f19c400acdb7d80d3f476acec7bad3344ddcab48e5ed6b6e4a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c8e7011b38721bbdf6a6c269ad3eb7d27de11c96150a9749bb1c9c05230626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45231625069354a55a35a68de5078194233bd15f2b3ecae67f23ecdcf8e329a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff27da7032c53548d8dc973d6fb7153f798f4def43c0517bf49e54633e1aab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "127a0558b7261226ed412b7dfe3c12ddee823b06b373906f107fb8f7af2c0bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a7545b234f98de9016a6bb67347aab236d16e600daf1d3460439eb02b3af342"
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
