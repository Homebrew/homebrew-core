class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "d73b5334e2960e3a9782b5cdf11b6b66a6ac273487ca3ea65b6298d8747b7de1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ab9d63d94528350f094e278d2b51bcaa9ae891460ce6886682d73790669c369"
    sha256 cellar: :any,                 arm64_sequoia: "bdc9d4e2a05dd8c7896f9127ca0134d5d59e05bc059ee285afb18d7a424284c0"
    sha256 cellar: :any,                 arm64_sonoma:  "f55107c6792c370be9608402f6dce1a854a15fdfe660138a963e8642be17783f"
    sha256 cellar: :any,                 sonoma:        "5a2afeebe0c49ba035d769b970ab2a7a66ee2f24503d024cbb04d4ec5e19ab5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6398e7ff778ccd5e1bc2d58e15ba0b78a5775dd42ce7bb2af47f1ec65b57364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb467d90a5bfaf944b661ff952ed7ca6a823fc133ec0be6f34f354de5912616"
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
