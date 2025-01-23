class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "f8f7a5145fd7f0e9a1ef5083fb39bd4f45c3a0e11717b7ee5ea1b8e59fffdefb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bdbb785fe371d5f3df2a57c55f9eb8e5d9ed24d20a296e13a73f39b4aac9b4e6"
    sha256 cellar: :any,                 arm64_sonoma:  "54eb9b1b0829fb5e93012db968322573ad8883ac44dd801e0a856e6838a467f5"
    sha256 cellar: :any,                 arm64_ventura: "9d1ecc67123836ba6aabbbc1438ec9d85717c4cd4fe662296d20baaca9bf1532"
    sha256 cellar: :any,                 sonoma:        "ede8c4a4aa8b431764efe1f51dbefdd3747ec1e5067082c310c849fd55915152"
    sha256 cellar: :any,                 ventura:       "363987fbf28e6000ea4c4d20e9de1b9f955f55651fcf51f9100190b589b4f4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6217b66dfabf20c1eb016aa8e5a4b392be1ca9238b3d4038d6189e7fe4fb3f82"
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
