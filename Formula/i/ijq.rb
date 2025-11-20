class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.2.0",
      revision: "f32d134098dba2b2a716bb6fb70804a8ba7b2b43"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c43fcb146ba1903decacf72c0ab569035a1a5d3c19d3503ae592b288916c3147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a866e7b604fcc74ca262c634d6aaf6bde74ab42cbc204298606fb2a987b2e6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610375d91fc47944952ef7bce6fb62f97c6a6e36d2fa2a3d26a700d1b2d5d124"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cba22abd874b899eb396080f3424fa38e83b409a2cfda71e4e9620c43fd3ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a429c7e742c66c233c89cfbb0595027bed11bc6341aa84d89f027412e8e3539c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc37538aa6de1547fe23c55e135397bf14b606945bf299587308b285eb8e57f3"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "jq"

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
