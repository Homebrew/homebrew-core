class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "58f4338fef0012858aeec961873948f37e9bc0167d68ae4cc1b5f458e4206610"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c544f2061827743f5a311fdd509fe9c081d38ffd8e6acbafa56e338401454083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731cabc9b0aae6929052f5c5b655a35ffdf0a80e1d9c75f0ec0bf843917ff988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b146c9a71d86d30711c487af3cd23677a5cada25d6600dd3abf66a06bbb8e706"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f1dddc53e6bfeec58d003ca8c445f88a36b9c930bd60c768543ef42970a6cb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dba8a1267530a24c25649c9bc172fbf22bed10759b7ed9364e84bce71374fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b156d995bdf417593fd9327f812130d8a353de01993023229d814f8b2b3ccef"
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
