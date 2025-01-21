class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "91727456f1338f511442c50a8d827ae245552642d63de2bc832e6d27632ec300"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e235d4677ccb8e7f3509fa48627dd99f101e4190c8c1bc0ee8ce7bae63809f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e235d4677ccb8e7f3509fa48627dd99f101e4190c8c1bc0ee8ce7bae63809f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e235d4677ccb8e7f3509fa48627dd99f101e4190c8c1bc0ee8ce7bae63809f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "71422cabe0b699c7d1377af00fa93c4726fd553263a0dabfb26301c739cc6b99"
    sha256 cellar: :any_skip_relocation, ventura:       "71422cabe0b699c7d1377af00fa93c4726fd553263a0dabfb26301c739cc6b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d499c506e5c639b1e08d96bdff5f9673a9f2dc1add172aa52a2a360d6409ad7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
