class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "https://bombadillo.colorfield.space/"
  url "https://tildegit.org/sloum/bombadillo/archive/2.3.3.tar.gz"
  sha256 "2d4ec15cac6d3324f13a4039cca86fecf3141503f556a6fa48bdbafb86325f1c"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03e55627ed6afed8053bd7b008a7097acc3cabe631c72aa37779c1a1bed4671" => :big_sur
    sha256 "e357ed7326ddf882e90730882661cd701d2b44cd878c46a60a3902276100f9be" => :arm64_big_sur
    sha256 "3de46b1bf2270bbc62922a26cd95e5096f8ff145538e2a648309d1e09a5c9ff9" => :catalina
    sha256 "2aa718cebff527b3ecac75022b1c9ecf602cf5f516ca09dac2a2c67df22a435c" => :mojave
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
    assert_match /Bombadillo is a non-web browser/, r.read

    status = PTY.check(pid)
    assert_not_nil status
    assert_true status.success?
  end
end
