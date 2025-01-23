class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.16.tar.gz"
  sha256 "fd533468e0ab23977243d4923715dc010ddd9d299f8a3d21c1252cfc1ee009b9"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0050da2e852811d504cc2b0aa1e386a13948dce010d1eebcadf2245b54dcdb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c55f84e986d136a051b4b33443f7050cab203b675aabf713aaee9fe4edd362"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e15f5685585c63301705164bc6c8872fc299ced9ba25e3b3c5275bb0aae69f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8cc8cec1f98830cb81c86ad9afc1f54073f18007cd97feb093b01f244fd87e5"
    sha256 cellar: :any_skip_relocation, ventura:       "e5dd18a541e742148c289f832eb24c63ae177059b7f94298c44936de49d8f945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b433065c82aec492f84ab378e7ff1fd703fa6c9d531d30b2ecfc1ee9f9b2c76"
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
