class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.5.tar.gz"
  sha256 "cbea1c73f1bf262571ba42797a89fc47e0b51ebe7569f1d384cc195ddfb29b09"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c0fef3aed136966f0ba7061a138693fdafda0d6adba73d6e8f23877d2092092"
    sha256 cellar: :any,                 arm64_sequoia: "90dfe387aeb5ba8178b518eee20034dba07acee88684560aeb6f9ca8c489163a"
    sha256 cellar: :any,                 arm64_sonoma:  "6e36f92b1e98177adc221947b3eb395bf64ae8925cdf397c4d3b1882d11c75b6"
    sha256 cellar: :any,                 sonoma:        "551faf7b2a1b7617bbf9d0c31dd512447c4e845c9f5d12a430af0eb577ddb155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2769604060486e0f14d4a6a9c0b353031e2a310836471aeed505b95c17f6ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03528b719cda3ff42ea486bb246e66ed76f78e0687dedcd6d365c6d5777ca36a"
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
