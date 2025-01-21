class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "60c000026dd33d82c439bb4a926c1afa11694edaa59dbfdaa336516e052c7b44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "158c9d50aa7b82b95d0cb7c97a8df4cc84471d00c9a179c688cb13b4e754ee06"
    sha256 cellar: :any,                 arm64_sonoma:  "0d5878d82f417b1e8d9c7ec41905de9650446e4717c67cb21310f08d51500f2d"
    sha256 cellar: :any,                 arm64_ventura: "e626c553a6e2a6c88a612f89ef8dd68440a59eb04c8a930693b93d82ac3d415e"
    sha256 cellar: :any,                 sonoma:        "10ca8b30ada6f3f322ff0b3b733c77ed2a8e79439b0bd95c17fe5f6b4d0de47f"
    sha256 cellar: :any,                 ventura:       "2c5fd9e94e81544d2dfc54fd7600ff69c14e9b7c2358d4620d83b4ecaf514767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c27887d6e00bd2be1b802b254df54e97d1854d795f0a4a0d3f3fa58733ed57"
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
