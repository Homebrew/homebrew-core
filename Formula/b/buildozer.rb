class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "53119397bbce1cd7e4c590e117dcda343c2086199de62932106c80733526c261"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ed75fa44e97d084b144187f15887c616c9d5e6b845c761c30cb2ea61f8cbf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a249d9ed33e966cc6af1cbc240863f9c08da7835812781908215d9656f66f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a249d9ed33e966cc6af1cbc240863f9c08da7835812781908215d9656f66f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a249d9ed33e966cc6af1cbc240863f9c08da7835812781908215d9656f66f5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec76949ac1ba18f851875ebc9fdedea90a20807cb4cfb6356e538e55b19befe"
    sha256 cellar: :any_skip_relocation, ventura:       "5ec76949ac1ba18f851875ebc9fdedea90a20807cb4cfb6356e538e55b19befe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f244ab0870ca8d972d148030a493be5c2b1b17ba375b2614d5e4f536f6f70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9539ecbd3762b9bdd61859a66c80d68f7e85f24af7557c3bb62c47840d4f7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system bin/"buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
