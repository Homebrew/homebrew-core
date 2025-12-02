class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "6bef417cc616c1d237e163786c3dd52f123e14c22673732a2e3c505ac098f246"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cce86762ac31d085ece5ff38ca39a1985b843a1e3ee7e4b3547c4899f9bab712"
    sha256 cellar: :any,                 arm64_sequoia: "c6617e275a4ac238414bb89743da20228f86d5efa3efd73b6e183bd0fc52cb43"
    sha256 cellar: :any,                 arm64_sonoma:  "10fd56be64a6050c0f5eb581f90f7414eb091cdd82ce1251897d6ccf59205d64"
    sha256 cellar: :any,                 sonoma:        "4a3b6e6a535c347061884c1f70fcd349e0fba19064b146147696e3dd159adf4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab5fc00df2b8b72e1e8ec8d44634dee3ee6e0b41d44a7cdab68199175cf6e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a9f82c3da844f87bffd3adfdfdddb0bb329593b46d156a341076f8945d3cdc"
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
