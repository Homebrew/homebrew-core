class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "78f83442f4646f185e495177b053f695384b22a99ac5e21e67f77dba75301c40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcdd604c2e4d2b4cb72332fa6350da7e841d7635f8d1be8a88d4a7e69a1392bb"
    sha256 cellar: :any,                 arm64_sonoma:  "da76659b036c5497a24303210b51b40f4eda8719d4cf2b35ac66999722d244a1"
    sha256 cellar: :any,                 arm64_ventura: "d4f82b8facd2a8d5f6c6d7265f4dc8f0704ecc77b9034ffa4909cda9b7e8a336"
    sha256 cellar: :any,                 sonoma:        "b265e86f0adc90211afb3992788b2aee637b0982c13fd5451e4389f7c68b9bb6"
    sha256 cellar: :any,                 ventura:       "7aba42a2b569bf55ebdc64d43c4335e9169485a6371b3fcff62f1b1c9ac0c5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "907c9f779b4013392912f3fb499770f4ff59732abca6c4f20f82cc50fe8cedd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d499e3d51f573ac14120c88736691b99a4f691df70bc502251dc14c9d86c80"
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
