class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "https://bombadillo.colorfield.space/"
  url "https://tildegit.org/sloum/bombadillo/archive/2.4.0.tar.gz"
  sha256 "e0daed1d9d0fe7cbea52bc3e6ecff327749b54e792774e6b985e0d64b7a36437"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e26d1d89a51dad792be45b0ea71013d7b22dd3fa6d8709ac85f5cb8a8467b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e357ed7326ddf882e90730882661cd701d2b44cd878c46a60a3902276100f9be"
    sha256 cellar: :any_skip_relocation, monterey:       "79338cb69e6372ae3c7fb62f3ca46e55dae5bd35f9a2734eecb50f44bcec7be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c03e55627ed6afed8053bd7b008a7097acc3cabe631c72aa37779c1a1bed4671"
    sha256 cellar: :any_skip_relocation, catalina:       "3de46b1bf2270bbc62922a26cd95e5096f8ff145538e2a648309d1e09a5c9ff9"
    sha256 cellar: :any_skip_relocation, mojave:         "2aa718cebff527b3ecac75022b1c9ecf602cf5f516ca09dac2a2c67df22a435c"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    require "io/console"

    cmd = "#{bin}/bombadillo gopher://bombadillo.colorfield.space"
    r, w, pid = PTY.spawn({ "XDG_CONFIG_HOME" => testpath/".config" }, cmd)
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Bombadillo is a non-web browser", output

    status = PTY.check(pid)
    refute_nil status
    assert status.success?
  end
end
