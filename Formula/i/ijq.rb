class Ijq < Formula
  desc "Interactive jq"
  homepage "https://codeberg.org/gpanders/ijq"
  url "https://codeberg.org/gpanders/ijq/archive/v1.4.2.tar.gz"
  sha256 "1c19df50facbf5374fbd6fc04edb20437e2605c712b592a8fb5dfed033fead5c"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/gpanders/ijq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c7cd4f3ad5a4b423396510d1f871c9d5c2162c1333fb8dee4e1daa74dd898ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58a34da35d3b607e8badcac6544903c3460b4eb3be4e4a5dc5a7581e12cf1a16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "430a888f17b6e28fe8bcb42200ca82d1c568c349acbd5f14088c571231c3fdd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82cd5a99240fd415074a4e8e09e94976b35d0cba7ff88a2ef25bbb4de11aca0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10148fe94e083ff69693bac5f80d797cc0a7a4ad8f47c5b12d6f8355b70b63c1"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  uses_from_macos "jq", since: :sequoia

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ijq -V")

    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'
    output_log = testpath/"output.log"

    require "expect"
    require "pty"
    PTY.spawn(bin/"ijq", "-H", "", "-M", "-n", "-f", "filterfile.jq",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      refute_nil r.expect("barbazfoo", 5), "Expected barbazfoo"
      w.write "\r"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match "\"barbazfoo\"", output_log.read
  end
end
