class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1c95f78c1b432b4a62392c971bc28eda8bc6754ec53e0701de1c42417c058bdf"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bdd67c44a509ff7b2c12ded25c6adb9895d7e9464245c85a3f861d14074a22c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fdce82bbaf08033a3c8c1c5037d6fd6e36fcca4e49ef685ccc5c136c80db0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2702c8f437b9ab36a8af2840f3144c4ec77fb7f2d036b35d986f0b41f5ab53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed688b7c0ffc77627bd36abedcbb78d5b1d3e5f85698dd2a25d5e539fa42e0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef843b3fb7ae68218d25840abdbd5a5d9766468bd521a4dd883165049695f35b"
    sha256 cellar: :any_skip_relocation, ventura:       "683645b88e37d08c941dd0926b19d8e5cde9f4b7280ca81618bb91a14e3966fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07121fd05dba24412d587abb6ef57f5be1ad4efd8129bb86ca6e9a13737b8552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af2d0fda64c6909530a07f24d49c5e71dfe7b11b6876ee43f57f299c14f6ee99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
