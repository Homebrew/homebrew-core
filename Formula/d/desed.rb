class Desed < Formula
  desc "Debugger for Sed"
  homepage "https://github.com/SoptikHa2/desed"
  url "https://github.com/SoptikHa2/desed/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "10e7836f484d15e545e8c43298ca7f6c6de75278f9778e03ca73877f98c9d25f"
  license "GPL-3.0-or-later"
  head "https://github.com/SoptikHa2/desed.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14452eeba16e2de5323d479c2845fb18691847306a8576d1cfdcaf8258456796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7527e806a595841c4837ab662fc324ac33916307cf13bda079f24977af180141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2979368a475b5c25858f1756a9e897133d6c082c349f187f633f99d3cf7844ab"
    sha256 cellar: :any,                 arm64_linux:       "f56cc056aa2b336d1348fc253598d222a799a443b3b06280874045c126465981"
    sha256 cellar: :any,                 x86_64_linux:      "10ae6f009ec7a51697370a983cbc6098ea77ef0b46bb53b17c7121f4451d9873"
  end

  depends_on "rust" => :build
  depends_on "gnu-sed" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "desed.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/desed --version")
    # desed is a TUI application
    # Just test that it opens when files are provided
    assert_match "No such file or directory", shell_output("#{bin}/desed test.sed test.txt 2>&1")

    (testpath/"test.txt").write <<~EOS
      1 2 3 4 5 1 2 3 4 5
      232 1 4 526 2 1 1 5
    EOS
    (testpath/"test.sed").write <<~SED
      =
      :bbb
      s/1/2/
      t bbb
      H
      p
      G
      G
      p
    SED

    begin
      pid = spawn bin/"desed", testpath/"test.sed", testpath/"test.txt"
      sleep 2
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
