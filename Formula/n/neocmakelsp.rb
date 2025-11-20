class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.26.tar.gz"
  sha256 "a400e86420cc7d67008a2139c3d7d9853b2775ffb5b6c53964775ffb505e5a36"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11c0b94120507fc287040e1e18f59eb253cb39a0af0c94a15fc70790aeb471f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d07e3ec172dfc1fca59ab2735859408cb2fb410906a89e886936def39b8af8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fc387dffea4717157f8b9400d20197b3d8dc7bca7d76781b3a3c4bb0f2d5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "01ff660c12bc18ed4efe31521cac0a2d9133809112d00559513574023d82d8cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f49e44a25b7760d34e884e394e5fdfc68567f196f6ce6513eb6fd3d91a2659e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0846f311d460e825908bad1ed146201f22c23fea5f87b3c2daf925985e2d0754"
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
