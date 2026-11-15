class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "8cbed3e0f0f8b4276bc097541aebd3db3434903fb55f1d54b41e31b8c44aa703"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33cdb839aed27331cc6c101d7625e498f111bbfad76dcf0233bae83e7e093978"
    sha256 cellar: :any, arm64_tahoe:       "6db1d1a0f6ad24e80bdb42665ff8f592807ba5a1df16543e76f941bdaee00d40"
    sha256 cellar: :any, arm64_sequoia:     "17bdaaef2cb328e6f7ee56c4d84cb15fd1e13b3dcd8d742490f07fe38b1f19ab"
    sha256 cellar: :any, arm64_linux:       "894f2250c132207af97e27520e63f3e2237acb8009622feffc5487a5f1d51e1a"
    sha256 cellar: :any, x86_64_linux:      "bb5e75262962daa2ad8bfdbf0b8a17472ccf559e9df7adaae9fdaab5ee8352b8"
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
