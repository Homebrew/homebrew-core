class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "1f67f68aa1a16162429f6939fdaf39ea6fbbb79eb376008a5d9b49321573dfe8"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9bf3f10fa776cad397a02cafdebb7c4f23a8554505a58920fab5c22db1dc9c0"
    sha256 cellar: :any,                 arm64_sequoia: "555aa1e4df7fd14c945db84bd9500cd6d1ce8ce509378f652f0e44159d13d648"
    sha256 cellar: :any,                 arm64_sonoma:  "718f919cce23241d2a7b84fd7a6e570165fd8506f0ba99fd1367408c6117741d"
    sha256 cellar: :any,                 sonoma:        "e752ee74325e11e048201631e709c4e3786faf0b47459e5abb789e33912015f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5bf03830e8a47b07afab846545d1947b5ecc69bc53d4d4a6266e0a668f55bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca10b1a42cb32f5e7d8140d1c15cf135f2014973e8dce1262b3b4d8e53880473"
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
