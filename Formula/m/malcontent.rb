class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "a4645ce8932468bf8ad8da80eb3732ceb939ecd8c89583b72bfeb022ee7901a7"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d5fb1e3be86be0d670a8748e4ab98e959013b747883641d62b89e6243d1b401"
    sha256 cellar: :any, arm64_sequoia: "b1baa508aef20d0715502b2d154c1b071f14bc8fcdbe09024ea7db3b0575b215"
    sha256 cellar: :any, arm64_sonoma:  "39eba17926ec4dd5faa713fb2c0ac0726e9673be165917e7003b4a1b35c6635c"
    sha256 cellar: :any, sonoma:        "0b9663179dd2dd6c473e8b709c885584bd7bfc88a5020bfe26d853070f2fe838"
    sha256 cellar: :any, arm64_linux:   "09c44c798c8453d5c6eba2383b33b015c0d43a6910cc7c49ecbf5358125eb69b"
    sha256 cellar: :any, x86_64_linux:  "1872c6e2bac29091167112a1deded0fdfd38b53600d41d8c4a85ee8b4297d916"
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
