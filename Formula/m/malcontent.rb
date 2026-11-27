class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "752370f44512f05a1947b33d64048f96a895d82fd02db7aabf0116e103a03b60"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    manifest_sha256 "28eec04dc048c8f4e1defa7017d8c479ac21c0ff8c035e94feeebb239f4d5fbf"
    sha256 cellar: :any, arm64_golden_gate: "5cd4ddfa0971f285f93c0f531e712ba0aa813832502ded91dad1bebaaf024b56"
    sha256 cellar: :any, arm64_tahoe:       "529cb4118c352c9b973e92e8494d8ad49f0239bfebc520867a661d2ae8da339e"
    sha256 cellar: :any, arm64_sequoia:     "0daa0f6f3b306d09b2f13614b7990b469604a306b0200135d272e686c2cdd437"
    sha256 cellar: :any, arm64_linux:       "48ca32b1a4bc9ac64cba9572008847eb43c64b8e871a2800bc82ba27a09569c3"
    sha256 cellar: :any, x86_64_linux:      "8965d081146e26011c150b104cc0c05113347d648ffbc2ac7402489ae80a3d33"
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
