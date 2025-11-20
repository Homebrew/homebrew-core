class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "60d4a194a6c20f0a315463d3948daeb215203c2b6f1e562344a79f9fa7ce5a52"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29e5849946d03457a1579db6608128df36b27257c7b3cb1e8f080b26ad590ce6"
    sha256 cellar: :any,                 arm64_sequoia: "5479fab0bf392678e3eddf2a9ff825f3dc853a7dde0d4a2d8597cc8a67d9d7ce"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6abb1073cb351b7ddebd283e7b93dfdee7d429478cf7c6eecab63a0e51d498"
    sha256 cellar: :any,                 sonoma:        "3f3a64a0c07cbeae4184a0290dda2d9d656e43b37365a0b2c014185f4012537d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b235400393b08470e7336c6e89d8eed9d8f73783f14e53fff5019584511074e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2136e7bfbad9ccf76795d4cc654d38962238b9e9ae116d6e0a7ebe3e77e0f3f0"
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
