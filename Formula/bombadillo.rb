class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "http://bombadillo.colorfield.space"
  url "https://tildegit.org/sloum/bombadillo/archive/2.3.1.tar.gz"
  sha256 "e8076493e924bd5860d3e17884b0675ea514eea75e7b4e96da1c79ab9805731f"

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    cmd = bin/"bombadillo gopher://bombadillo.colorfield.space"
    config = testpath/".config"
    r, w, pid = PTY.spawn("stty rows 80 cols 43 && XDG_CONFIG_HOME=#{config} #{cmd}")
    sleep 1
    w.write "q"
    assert_match /Bombadillo is a non-web browser/, r.read

    status = PTY.check(pid)
    assert_not_nil status
    assert_true status.success?
  end
end
