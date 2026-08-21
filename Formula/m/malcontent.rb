class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.9.tar.gz"
  sha256 "09462e2c22665b67ecb7b7d9dee21fc80e6a3505bc14a93df5cf3738bf3abdb7"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "93a277134450d0c0b72cfe450e6244030b8dd6f8475661970e77ee928edd4fb3"
    sha256 cellar: :any, arm64_sequoia: "9ed3ce2b91e6fe151c283931f76c4c9bc3fc9e460c13c44f07d6de02cd88b7eb"
    sha256 cellar: :any, arm64_sonoma:  "86bb70882fe063ed84b133f1b28196077704bd4503029756cdefb90985ddc724"
    sha256 cellar: :any, sonoma:        "475a5529240b9a068ba67a3605053dfef25f70aa2a2967aecffafd8e5a8a6766"
    sha256 cellar: :any, arm64_linux:   "471b57071de4661f176c5ad25f6be44623f7453c369c421d9e76b00c89c11e7e"
    sha256 cellar: :any, x86_64_linux:  "c45b83b7112ea829fdeaa63bd57c464f5f1072451342c64f514b56dcd376aae3"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

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
