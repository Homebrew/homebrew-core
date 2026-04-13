class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.6.tar.gz"
  sha256 "33bbe46a557765fb13875c235bbe12aa7c5bf2f199ed1977e6e1d8e0b400eb1c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7f62f81582d3c19656d344c3557590184b3e9873b10f85f834aba3c99874947"
    sha256 cellar: :any,                 arm64_sequoia: "e8b9cc3c1b1725e587dc3e5e022cc8e49ccd5c82147e3088de1bf001db78736a"
    sha256 cellar: :any,                 arm64_sonoma:  "183b15eb0dbf55b304716ff495f572452ae9eed4081ce387ab0a69de27e62e2c"
    sha256 cellar: :any,                 sonoma:        "94104893de2086e8c3951b58dc5a5b2d6976990508727e98f35e66e009999e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c8e1a12cb740e640bbc6ef9cfdd71071b70816b3c5dba3fa1293483ede8e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fccdb93c9340c263cd39f77c6aa3b9dbb733c07362e129cd15d3f72181c2a71"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
