class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "7a8ba38c90ba56b05260ec5aa6df94dba98f127b3170ee8d3e394f28823e2259"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ade78fba433bb447629316ca5487b526e31d3b36c3ded459e6181a954905673d"
    sha256 cellar: :any, arm64_tahoe:       "fd612ef34537dc1f82cf7d97081b68a7c853b42d6bdc6dd0c8bbab825de9dd65"
    sha256 cellar: :any, arm64_sequoia:     "2d25525e20a823a98a2fd8c5cd7d99e764c0c7cfcb2d07d7cc4cc44c53da5619"
    sha256 cellar: :any, arm64_sonoma:      "1028102b29b535cc3d1d55de515e9afada7fd9e902405366f528777c46c10ea2"
    sha256 cellar: :any, arm64_linux:       "60c3ecc151ade18d039dc702565ccefcf93f307e21c8dd1cd39525cc60d34a76"
    sha256 cellar: :any, x86_64_linux:      "c12d08e0bbb7aa3ae54c234dd8ec95c7825ecd943535bdf55c9eab9e61363747"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
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
