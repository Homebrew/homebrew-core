class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "0d13aeb805592295638744c4659c574e4b187a85e15eef5bb9bc8d9d47c28bec"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abd9bc4d63c07f9bdb9a7236039d56469bfe1831878d6717e2583bb45947a4b4"
    sha256 cellar: :any,                 arm64_sequoia: "382423b1d69e27dc4cd9eefa78ee2cbbf746fb58ae2f43ef5adbf1d365285ed2"
    sha256 cellar: :any,                 arm64_sonoma:  "27129313f1bbca192987d0e2fb9f23cb9395768382f33d61c0518de9ee8924ab"
    sha256 cellar: :any,                 arm64_ventura: "4ed5db01ad46dcf885c5e7a793dc87927f607f62017e558f663afca4896833f7"
    sha256 cellar: :any,                 sonoma:        "624d16f5aaed04fe01e07b3b2728bb2c16dd38f8e4f2ae4277af8e40bbd15938"
    sha256 cellar: :any,                 ventura:       "c0ea77305329c08a47483bbdcdbda1cb11a3106c5e975dcf1876c7a014ed681a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7940b1bfe152a4631c75a68e760d5902ea1a66541847247302d4647e80c74edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0974953f5c3e0a50675776f877f37b1b0c2f5869c931d39f7048bca63952aae"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
