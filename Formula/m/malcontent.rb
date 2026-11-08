class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "8cbed3e0f0f8b4276bc097541aebd3db3434903fb55f1d54b41e31b8c44aa703"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bcf09060935c533f0ab5a8aefd83fab2456f0e871e39d23ce620c31631caea81"
    sha256 cellar: :any, arm64_tahoe:       "9a1ba6d6e0a3fc95b4b5f7d7d8fe098e64944ca14a431a0e26a467f7f8efc789"
    sha256 cellar: :any, arm64_sequoia:     "91e52ed4b3b8feab6373c625cc3effcdf5a0c76b96879847aac2701f62c4eaa8"
    sha256 cellar: :any, arm64_linux:       "5ffaef43bb74039d32df6859f2cc2654acd4fcb7c83d16ba86961ba625aa5c41"
    sha256 cellar: :any, x86_64_linux:      "0139670c8edab1b58ada3294890a4515202b01b42dc40a23c8882ff9a706c191"
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
