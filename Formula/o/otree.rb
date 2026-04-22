class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "db510e42f622bafa9d1fa1d8a9680c64194058b864bf72f7799ebb1db3f12ac1"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc284b6852155633602e05b83af7abe3beca93ca3cd0c2fb0e6b381bd5d71800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfe228d721e046bbc432bbb07ce51b24636e19e8c8a4c3121bd31c1bc491599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6aa21316b114197bd4e88b7fa8a15b041c3e2b42d7e4a3cccaff1fd655a7dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c17f845069734c7c8b2425df273a621b4edb3f9a15d3a740ca92c386b355659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fea68fc6e840268433b89bd037722198e60bd2e61d26b84cfcc1205596cfeccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35e12e01dea0134aa2d1abf921e96ebad8a1cdb5a6de267362d1e3f85116651"
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
