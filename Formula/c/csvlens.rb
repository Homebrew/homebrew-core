class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0f8b14f929c5acdc697187ba5c5a1ae643f97dcfc9325847c60f78cb73a6328c"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20f7079cea5383f40fbbd360deb7f62cc0ecc048e4e0832bcdbdd8ddce23afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "259a695d57fb7b09db11ae0dd6ce556e80f0d73580cd3c55a3d54883b04087cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06e7f2e958ded46ee8643bfb8c68322dfb8ee3b59059c2a5134e2329354d283e"
    sha256 cellar: :any_skip_relocation, sonoma:        "11c929adbb2946005dbdeb334555d30e7a939221130acddcfc347146aebc4671"
    sha256 cellar: :any_skip_relocation, ventura:       "58787d25673dae586f38dd1744c1e817f339f2d8a5808ce0a7116db32cd7db4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7b5d8fda5ba5de5c35eda32212dfee9a2a15727afc0b69694cc578d6ee6868"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    (testpath/"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin/"csvlens", "#{testpath}/test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 5
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
