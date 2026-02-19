class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.1.tar.gz"
  sha256 "b1766cf6fbe798b4d57b51adaae86c442b5cf829e3ad8ef85b682b4acc239dec"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58399f491b66ef2d86c62d04af516225d01da7579869d70164abac090aac8b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e734e0ec289211cc852d6d21b99e53324f45960b69ebfb950b8182440a856998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f8e7fd98945f45726eb7da105eb93c91cbb2e345842b90844035b79e1f8bb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d5701bf985abf9c2783aaa538732096ebb1a17e024a94d3cb0909ebcfcc7e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e172b2aceb629f26509208085e7f232ab44eed1e6b1cb5be19ab1d4bfa8de939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54b35681e16d7ad4b352e2fc245bb20ffaf78ba3cbccda7cf1a0d8803210c11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
