class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "cb331829862efdc0a7d2a10abdbc47fbcfd4af3b6c9978b213938b756c87a180"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b9e54e7a03960d43519bd4095614909133d6155acc91b3e91e759a4a71074f32"
    sha256 cellar: :any, arm64_tahoe:       "d9bb6237de522a9334e01b8a6b2a95a3fd3249173075fc615b5289eb760c7a9e"
    sha256 cellar: :any, arm64_sequoia:     "564155b93a83e21d6474e4aff00aa174c2691739d53fa0bb766b0f4da84a8d0f"
    sha256 cellar: :any, arm64_linux:       "9e8ba41c3b5073d776b63cf8126ab6391cf67fc87d1a658ee6f46bfb06e1f406"
    sha256 cellar: :any, x86_64_linux:      "564a47d6984803197c6389994e5abd34366b27909b8c294838b93c32e8a539da"
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
