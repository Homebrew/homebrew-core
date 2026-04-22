class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "c13561e12027e39468a9a7949da9b454bf14140d99001477e4e90dd1f1c425d8"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7601a98ea5595347f5bab4d15637dfe53d42fc534d250da8310b7e6a36da27ba"
    sha256 cellar: :any,                 arm64_sequoia: "3637f29b3da8892d1a8841b561be52f8217165762092e3300dec9fefabf22e29"
    sha256 cellar: :any,                 arm64_sonoma:  "cb56363af16a5da7d031ecb2186f5d152aa1f7d5985f37e85b94c21fd7e773e0"
    sha256 cellar: :any,                 sonoma:        "4c99d178dd7fadd2efa3dfa0f9928488604e557c65ec05c11afb45fa23010929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e44082449bceeb6e86bfd6b1101e1294f1b36ba09f7644436c736c75123c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e4e87d43b0d18ceeee42dc67e25c4cd4df098903dc84404f3ccbb77b82d2ac"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
