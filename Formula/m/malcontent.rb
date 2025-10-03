class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "8fd29ab7652bf54b1cfa6ae7cdf43cd2a9a8ddd8d37d8c8b954255c5d7078abd"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c78ee6e7031cfb59d810e2fad5e122ee87d7695619a279386e2e606566db011b"
    sha256 cellar: :any,                 arm64_sequoia: "defbc66fb2bd4c6961a7f156feb71cc3f0e199ef1c5c045850646d2e95f715bf"
    sha256 cellar: :any,                 arm64_sonoma:  "d20e7383403810585bd6a4975482eac3ea64a635661571003e181ca1b1f5c16d"
    sha256 cellar: :any,                 sonoma:        "ffb7315ebbad33ca6fce405c1b2f6fd224dbd40e96161f1a18eeb85a4904205c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94d85f544d7f13a162d56367b3d3842d019467c78f80bb11674b34f45a53724d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b63476593835cfda851d1b47a3d1b2daeb84190a732b218591500a87d99f55"
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
