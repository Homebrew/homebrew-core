class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "5af90068e9e8812abdc455ad04cc474470bccc8bbabc8b571e3f58a66799680f"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc7fda4afb798da9aec69f3ea70d6850de19622fcb43cef163d070e44e938627"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc7fda4afb798da9aec69f3ea70d6850de19622fcb43cef163d070e44e938627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc7fda4afb798da9aec69f3ea70d6850de19622fcb43cef163d070e44e938627"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "55103874a8bac3ddbfeefd934707e5c000c9cdb83c09382801a70c0ea4c62864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5af593934075a34a420fd02bdbb3c5270cf19fc01d6552b5311d0567252b94e"
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
