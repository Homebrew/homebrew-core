class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "9a0a412603c9374a39a05f3a3f2e9ece32606e3e5858523ae1c27d87e347349f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3aa0fa3cf4e4ecc8fae555d894e76934448bf4b6b2f980d837d2a8099f14d3bc"
    sha256 cellar: :any,                 arm64_sonoma:  "086a5eb0535429af8ae358b96dc1910fe42e1465fa2fdcc88cc95e00ad4d7881"
    sha256 cellar: :any,                 arm64_ventura: "d97a80b78a1daec1b1f4aa281809858bcfdfafd283b3ffad538659c48fc5b41b"
    sha256 cellar: :any,                 sonoma:        "3bc8e1ce3cf082ad549a14f9b1bd7779e15131370cf3cb96af9839b6f6c8e2b6"
    sha256 cellar: :any,                 ventura:       "26b32baffc565e7818f3f56b232d811d9e7d1c2afaad1212e72f081482496e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e40a5a136b32e805be5fb017309bae59a95cd0d3fa6c51b38be7e2981b819c"
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
