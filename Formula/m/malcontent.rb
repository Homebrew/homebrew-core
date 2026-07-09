class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "b0368e9feef7e8d5bf453c2ed29c40a8146d074eeda85d010bc97f8953886cf3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb538abd47884032a24df871d8bc11535afc0af6b48cfe7523995ebb2d809a1c"
    sha256 cellar: :any, arm64_sequoia: "26aa4734b12b55bdde89c31c76c9cc4d50c897e0962114a00d30d117340eb004"
    sha256 cellar: :any, arm64_sonoma:  "1b24e7af55557677207390f152760c41d493fdb4e5d6cf1276f5eaa24f3885ee"
    sha256 cellar: :any, sonoma:        "9a339a11fb9626af66e89cc553b20601a2dd729cddcba0e3e70c4870ddafec57"
    sha256 cellar: :any, arm64_linux:   "ce77cff4dfb8282fc6ef40d441fff7a90450774a5343abc00ff358ea9b8954f7"
    sha256 cellar: :any, x86_64_linux:  "2da9eb0388fe8da60f37f699332ae7e803e3c8cfc28efa39d3c3abc4cbd34d94"
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
