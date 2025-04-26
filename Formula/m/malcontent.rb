class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a25bbc5b35db68bd9df0f0f46d1ced12d9b2fbdc777026fd55e6b179069ea7f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39ee3314437fe1c7cfe501f31b02d1e66f6dfdea9117cbc7e3dbc7372f2d50b4"
    sha256 cellar: :any,                 arm64_sonoma:  "9a92156d8da7c3400453bf5e49b10ede2c40b698426d9b28066e93e456f605e9"
    sha256 cellar: :any,                 arm64_ventura: "c2fa312f2ff1263be59ae4f29371cf852539d1f478c3907d07a0cd7f22d093d3"
    sha256 cellar: :any,                 sonoma:        "7e756797aa69e685907d21ff3e2bfedfe1fba50dd1552958449491c1d6f38481"
    sha256 cellar: :any,                 ventura:       "a474118b1ac44e5271e4351818fc587795ac9734b2b2bd5832a8997d85aae3f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b51d0a6bd528bbe221fcd6e51660ffc0e4f1f074442fc0af44b2dde65e5817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37fa5812b4d06cb7ef3dad7e68d18f97f58f162b2bc0a588576fb9af1313f9d"
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
