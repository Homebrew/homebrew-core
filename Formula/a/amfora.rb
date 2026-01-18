class Amfora < Formula
  desc "Fancy terminal browser for the Gemini protocol"
  homepage "https://github.com/makew0rld/amfora"
  url "https://github.com/makew0rld/amfora/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "76ae120bdae9a1882acbb2b07a873a52e40265b3ef4c8291de0934c1e9b5982c"
  license all_of: [
    "GPL-3.0-only",
    any_of: ["GPL-3.0-only", "MIT"], # rr
  ]
  head "https://github.com/makew0rld/amfora.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00e4da529415b5a5b02c68c987828c996e1b044e8de4bdd3bd91aff35d472396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea294662496a802b0b372ac96c71b78a6df62ff654855c243677b5d7d4e4803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea294662496a802b0b372ac96c71b78a6df62ff654855c243677b5d7d4e4803"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aea294662496a802b0b372ac96c71b78a6df62ff654855c243677b5d7d4e4803"
    sha256 cellar: :any_skip_relocation, sonoma:        "f50a1331ec6c174d16aabe9908dbe16ca7b840bf44c7e76b384de67b5e5f2f67"
    sha256 cellar: :any_skip_relocation, ventura:       "f50a1331ec6c174d16aabe9908dbe16ca7b840bf44c7e76b384de67b5e5f2f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9218f579fb7be31312ea53a6d59a7f6f63ea4a01216c64ab68b49c2899b34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccab595f65a7e440660a2981719199eef7e5cc82025a89f0cfa2936892fa57b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
    pkgshare.install "contrib/themes"
  end

  test do
    ENV["TERM"] = "xterm"

    require "open3"

    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts bin/"amfora"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "1"
    sleep 1
    input.putc "q"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# New Tab", screenlog
    assert_match "## Learn more about Amfora!", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
