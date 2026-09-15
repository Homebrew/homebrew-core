class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "f495fe290cf2a009e80b20d5623c7756890a8a45d83fc93d44a31ab92060c752"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c27208eb24415246fd77bcc1593a9f7feb1a7949447df13bd6f7ee1f32007851"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd9592a02db22ff8243d99081cca1da48e4f4fc4664bffd41b16dce39cb8d465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd9592a02db22ff8243d99081cca1da48e4f4fc4664bffd41b16dce39cb8d465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bd9592a02db22ff8243d99081cca1da48e4f4fc4664bffd41b16dce39cb8d465"
    sha256 cellar: :any_skip_relocation, sonoma:            "1b4609634a3f90b20b3104e6ed459ae0cadec118b659afff986ad132aa27cb51"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8263d5556d0dca20e40d99d0efb1befdc14dbec44683a1b9be36cfd6d701e055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "625424997cc35a8cf391d02c61788fc1c2b41d32e9a59ac63d24ebdfd33e4a28"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # go.mod omits the golang.org/x/sys indirect requirement, fixed in bazel-contrib/buildtools#1514
    # TODO: Replace with `go mod download` on next release.
    system "go", "get", "./buildozer"
  end

  def install
    system "go", "build", *std_go_args, "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system bin/"buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
