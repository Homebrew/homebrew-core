class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e2f6b43715cefc00f1a07c84bb899fddc5defa3f69a1a68f5a4051680b0ca4b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c6d0fcb4136e5a5ac5c5720dd59200bce74cdf884311258f55f4b030a858579"
    sha256 cellar: :any,                 arm64_sonoma:  "98dd6af3a8c080c6b9090c60fefd796c23b95f109838f802176a56e1d5f6c46e"
    sha256 cellar: :any,                 arm64_ventura: "4dc1ced5cf5d2cab87201af25d7b21f65ebe52dafaa9efe848fa1085ceeeeda6"
    sha256 cellar: :any,                 sonoma:        "e759a7ae280ac4d54aceef7681be3304ac0313c08ec4ebe73a70e3092c40d62d"
    sha256 cellar: :any,                 ventura:       "45a2c31ec4cff70a861cf10b841a541ae863946d7ccc6e2fb53eff29a2429844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971033b9af2ae9fcec299abe47b01cf9793a3e8f486999bee9161bd24e0dc8e6"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  def caveats
    <<~EOS
      malcontent embeds Yara rules in order to scan files and
      certain AV or anti-malware software may detect malcontent as malicious.
      Programs that leverage Yara will generally see other programs that also use Yara as malicious
      due to their respective strings looking for problematic behavior.
    EOS
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
