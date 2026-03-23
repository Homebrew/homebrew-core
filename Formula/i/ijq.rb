class Ijq < Formula
  desc "Interactive jq"
  homepage "https://codeberg.org/gpanders/ijq"
  url "https://codeberg.org/gpanders/ijq/archive/v1.3.0.tar.gz"
  sha256 "b65cf7f5285affe3ab9a1887d12e6c313f437b18a5cf2b52add6cfd7e76dd2c7"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/gpanders/ijq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f71e8a5e46903cb8f61ad5177ac882d6c652d427c2a11170772835216a4a025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6934f0c8a0ae8352ab44ab1bf4d1ed2d5eb79d59d8709371152d3f64f9101805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eb043ea52bdb123f3e673f084152606d02e35bec68a65231c97c7bea9b4426e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf74ff77d3d2af3f69e4d8f271bcbd39f4a42aed9802fc74e82eff9be044dd3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a091da8484e89d2cf988973d8c44af367fd59de321382fe50f96c91473a3f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252b73640ebef012fae413591033b3a90a820a96a0f8e6195b874cc05e4425fc"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    require "expect"
    require "pty"
    PTY.spawn("#{bin}/ijq -H '' -M -n -f filterfile.jq > result") do |r, w, pid|
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
    assert_equal "\"barbazfoo\"\n", (testpath/"result").read
  end
end
