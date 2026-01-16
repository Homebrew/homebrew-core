class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "1c917fc69f3b846bf32e09366624e26ad21108b37899d4f724416c3a71ff785e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a0bce882fdb86eae021d32362677f9d13a2b26f7c3a7119d0794a72fb65ff71"
    sha256 cellar: :any,                 arm64_sequoia: "84348cdbd0c4c8330e691dc37f24989a6d8e05c7959a0de47db6950a4476ba0d"
    sha256 cellar: :any,                 arm64_sonoma:  "9d550cb533bb8e94e59f3cbddff6b5c461cad9ca0ca033d9da769d2edcb86cf3"
    sha256 cellar: :any,                 sonoma:        "b0da20cd27882a684d590daf955e6514371ac18f2fb0e304644ac63258553c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90f298d390a5e762b5bff733d264784c6b8286011574dd56f7fbc92961ba8593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "861d59b159a79eb4aaac01ec7f412ce85c844f3d058283c906a04d348f8b8370"
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
