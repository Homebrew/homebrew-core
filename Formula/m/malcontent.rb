class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "4f4b26567d9c0d0e02cec72b735207f8aceb286d927d990373fbce4a4b56d5db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af552f183f008b463e2974917e656ab417faf3f249d0e51c6e5da51f5dfb4bea"
    sha256 cellar: :any,                 arm64_sonoma:  "6e27333867aed8a8fbc621d1d72ed9e661d4d51918751ca7582bf49daa0528b9"
    sha256 cellar: :any,                 arm64_ventura: "c02d48047cfbb781876368787fa0c255b3c869106531d2472841142bb40e2857"
    sha256 cellar: :any,                 sonoma:        "042714c73f5f3988a7129589867bf2c2ae79e94b65442f5b8378da2d5d0326d1"
    sha256 cellar: :any,                 ventura:       "d866ff753466b644470aeb1e8e3608762e0b7b93df3c0fd512f1e3cbe597e837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67373601a5ec95cd282eda2630343bd24968d4f92b4dec5c32464a6bbc19d563"
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
