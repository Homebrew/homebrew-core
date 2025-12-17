class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e5ab52ee8abafc18f66d332ad23f144f3a5f4abce76793c2ad9f69aa70cad1b3"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da244c21fb093f10b1222be2887db590100c059bdb10d4de8d99999fc7e00ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd92127b7d739728820c7ec8cd5bc3c4143a44f0db182cebefcfb73d5e5c151f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bd75e2862b754df570beac579d3bab3db6ce6f841c7dc0e4f303b53a44039c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbf7b7786b446efd7713a14c28703946e19db79e0b286056328d1b14c377656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea1418c70ba4fc24ccea040c110e7491653a9de44840806ce54c5fa0ed42332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1b416858ee03e2301f97a1e4e08fb7de6b84e781184846be65a21909937fab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      Hello World
    MARKDOWN

    # Use isolated HOME to trigger first-run font setup
    PTY.spawn({ "HOME" => testpath.to_s }, bin/"mdfried", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 20]
      output = ""
      found_prompt = false
      start_time = Time.now

      found_hello = false

      begin
        loop do
          break if Time.now - start_time > 10

          next unless r.wait_readable(0.1)

          chunk = r.read_nonblock(4096)
          output += chunk

          # Respond to the two required terminal queries:
          # CPR (Cursor Position Report): doesn't matter, just needs a response
          w.write "\e[1;1R" if chunk.include?("\e[6n")
          # DSR (Device Status Report): \e[0n means "Terminal OK"
          w.write "\e[0n" if chunk.include?("\e[5n")

          # Check for prompt (strip ANSI sequences first)
          stripped = output.gsub(/\e\[[0-9;?]*[A-Za-z]/, "")

          # Once we see the font prompt, press Enter to continue
          if !found_prompt && stripped.include?("Enter") && stripped.include?("font") && stripped.include?("name")
            found_prompt = true
            w.write "\r" # Press Enter to accept default font
          end

          # After font selection, look for Hello World
          if found_prompt && stripped.include?("Hello") && stripped.include?("World")
            found_hello = true
            break
          end
        end
      rescue IO::WaitReadable
        retry if Time.now - start_time < 10
      rescue EOFError, Errno::EIO
        # PTY closed
      end

      w.write "q" # Exit mdfried

      # Debug output for CI
      $stderr.puts "DEBUG: output length=#{output.length}"
      $stderr.puts "DEBUG: output=#{output.inspect}"

      assert found_prompt, "Expected 'Enter font name' prompt in output"
      assert found_hello, "Expected 'Hello World' in rendered output"
    end
  end
end
