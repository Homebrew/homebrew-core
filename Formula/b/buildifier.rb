class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "5af90068e9e8812abdc455ad04cc474470bccc8bbabc8b571e3f58a66799680f"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d4dc24173998a32a40ca6bd9465bc4448356c80450058eacaba09e58576ebc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d4dc24173998a32a40ca6bd9465bc4448356c80450058eacaba09e58576ebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d4dc24173998a32a40ca6bd9465bc4448356c80450058eacaba09e58576ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87a822a5c59047ea72149c9f2e9a0fc18ca2eb22e4b570ec45cbc87ee2ed85f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "528759254f8f6d0428adef80e51883822be70d31c725aa34b30ac837667e9d19"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
