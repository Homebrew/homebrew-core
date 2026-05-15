class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "52c2017195efdac167e2ff27aa86a92e58cad68bbc586fa2fc96e2b2852e90dd"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c4c9c10177398eedfd4cffe27bd9768a04e42acd3c28cc324c5127b10c0c0f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3218d87aef2da1e34d6d5835477d12ef152746703b08731ccbb542009f8d8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9223c3993096763e9d009af705c128652e8ce5a4ee60ebdeb371749c92d1520"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a03b6afe837aae14bd14c21e73b9e43ec24714df07e6da8770ade87dbecf8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f34dec6bc4713d8bb7373950f4596e2aa602d8beca2b2948e94545affcf0ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec41e4624b808c0b6b71b7241baab60c872ca81e592647d1b58f6db280cdcf8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/fzf-make > #{output_log} 2>&1")
        r.winsize = [80, 130]
      end
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
