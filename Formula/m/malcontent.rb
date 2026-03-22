class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "89dea64237c61d8b936db66c27a0b038db467b160d36f49b179f00ef550eb1c2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7654b7ca0c2dc56788e4344223e688c13f012abb91d9977bf17d0fb1e14486bf"
    sha256 cellar: :any,                 arm64_sequoia: "ec6cad3e311fb53251a1f1af356e426b585f7ae64806786b12edc5cc9e647950"
    sha256 cellar: :any,                 arm64_sonoma:  "3ea2ef9a2716d0ef68a3eafb47d4a6f5a1b81f9024793d4143349b8f8fb92cf8"
    sha256 cellar: :any,                 sonoma:        "ec4f8d818e738d6acce24185fe133a7462e18470027a269f150a2e87dc279c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dadee956c717b73bcba1c849c23806d1ee91fba5d8a88b0500f3b372c53b610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b73b170d044a4ced9ab18a149e9a44b6a9175c7858a53ae9cd4c2da5a646c04"
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
