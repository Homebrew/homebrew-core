class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.6.tar.gz"
  sha256 "b7b186cc2a79efa9275b3367d84d8a686278bae260e778f2491c79c5fd2b9360"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7549937f5bdf7634d79aef6915261af35063e1b20a28918cb60286225be6ca8c"
    sha256 cellar: :any, arm64_sequoia: "b808f2615b102b78ebe83ba119e5d4d3433209fbb4bcd21441433f1cb4eaf13f"
    sha256 cellar: :any, arm64_sonoma:  "e64ad8516ffc7706ef252d211f79e467be6fbfe366e3beab5712d31980d35bc9"
    sha256 cellar: :any, sonoma:        "1ae38c9af504fcb28b369ed8f8bebd6218e60a20c7169f409dc887ce367b43a0"
    sha256 cellar: :any, arm64_linux:   "0c3f31d58ec6e30e366902a0ec00b6a790befe552d5a77c2ea67e883a7e46322"
    sha256 cellar: :any, x86_64_linux:  "d96932212abb76012c12c2dc13acb00236ad5246197980a825a69eeb523936b0"
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
