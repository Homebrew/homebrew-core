class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "57c2c875522306776fdf4a39bffd778c56a97d0d0f30c6d3299414f88fb9af77"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a53d4a0682a245bca8b523a4664955ce8c61367820fca87e3b3dcb001b9236b"
    sha256 cellar: :any,                 arm64_sonoma:  "282be6c5ca79065ac90ebeac13e9bf567653337d444a9fd556da6c8c99e3cd96"
    sha256 cellar: :any,                 arm64_ventura: "7a9b3dea823f3b8e0154709453a5dceca87fd1cb479db880a8c0b9ae94444738"
    sha256 cellar: :any,                 sonoma:        "cf138476725e22233d412a0f33e2f8bd97e7e2412c913cf751a26f31cf6911c1"
    sha256 cellar: :any,                 ventura:       "0b3fb42c912b3d72b6903e9438da947957efbea58688d22942db8adafb6a23b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b1c9e4d22ef7ccf84ab9cfd29587899a84a7aabec6af01a576afa30c7b92db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60479f86d5a158a7b9b3746b37abd3f264dc6781d5086a7d1b71aab3554c5a03"
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
