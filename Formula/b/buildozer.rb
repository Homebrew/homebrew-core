class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "7914e09ee966e7498c4a0c365590f555c741c24b1dee022f60a2284036c2653a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8713ddd9b67b454b4c4af5864a3e394edc3a622684f4e21532f3d71dc580f820"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8713ddd9b67b454b4c4af5864a3e394edc3a622684f4e21532f3d71dc580f820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8713ddd9b67b454b4c4af5864a3e394edc3a622684f4e21532f3d71dc580f820"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f794a4507d5fc6d7c3e61adbcf131985f16d699109101847742b6591e66f4ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d12b7937f61394a2d90a0725d6a730c73f6d5d0b353a55dfc6085c51447b002"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
