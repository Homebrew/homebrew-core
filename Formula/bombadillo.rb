class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "https://bombadillo.colorfield.space/"
  url "https://tildegit.org/sloum/bombadillo/archive/2.3.3.tar.gz"
  sha256 "2d4ec15cac6d3324f13a4039cca86fecf3141503f556a6fa48bdbafb86325f1c"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f17f909fa5202ac56fa978fdff15ad2d30bfd5d7386ae223fa63a5b1857b7c5a" => :big_sur
    sha256 "d4cb984fc96583b1bf71dc482125b54d6dac9b46c47c6b0134183cc501cfb8b8" => :catalina
    sha256 "a2ae947fb7d64598be63f1e54ea66cc5325fd135efed9c16f1fc2220f362a056" => :mojave
    sha256 "685062637b7a2d279bcd9b002edd87e16cff4ce400bcb3c739899e95a652c809" => :high_sierra
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
