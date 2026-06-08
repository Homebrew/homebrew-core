class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "636d20cc90b3816b02ea80c4f107deb7a296b183d0ff624368ba5e86c8ff2205"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0173ad54d1b91168d05ffc45f4d60ea90f042d68d7876a1b98f12ee637392901"
    sha256 cellar: :any,                 arm64_sequoia: "161f980adb92be46f68b42f126d534040fd533383f1686d586b825ca675ddcce"
    sha256 cellar: :any,                 arm64_sonoma:  "b4599f45fe7b07df758e69a394817c73bb7900a12d549641fefea6c0a273f74a"
    sha256 cellar: :any,                 sonoma:        "751d4f44b65def7b8bacf3c9dae930a84abf6361d872e2ce10969cba4fabadaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307b206025069c06b60d87e78aa3e3cace8040ab863e757ddda4d721247d0582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cafbcfbdd00780deb277ab1a36a1691b750e8f78b69cc7c847edad8b25e862b"
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
