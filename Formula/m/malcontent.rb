class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "a57e3d7d6419e407a2dfe608f0629eab70817925df230b3f308256e1967c0e8b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c675b9b0d603b1e0acd06cac7d8f1df76b49cedb66a2ec1275d645e8b2dbd30e"
    sha256 cellar: :any,                 arm64_sonoma:  "12eebb5054f2eb5402f2e9c3631637ee92fb6d0024a0bb96307e694b58780810"
    sha256 cellar: :any,                 arm64_ventura: "1a032989e90bdb7d13bba29812924c7475b3b2b5ede4a9d3793b2b14bbde90b9"
    sha256 cellar: :any,                 sonoma:        "6f6a817a2b3e17c8dc2ac7c03b8b0f41c66f2d531e91edb706674743f59c5f44"
    sha256 cellar: :any,                 ventura:       "5cfbc8b9ec9c966ab92841925fa4933ff966878dc4aeb62a1df3d20a1e6f2bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44018ab4bd5d07758ac2cdc86ecf64f60bbd755671b73e1b6f467d666992b34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e137f0731c71c2feb59310f496b7f9f7811539485bc56069fdf15872d3f6837"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
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
