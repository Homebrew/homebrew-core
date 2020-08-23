class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "http://bombadillo.colorfield.space"
  url "https://tildegit.org/sloum/bombadillo/archive/2.3.1.tar.gz"
  sha256 "e8076493e924bd5860d3e17884b0675ea514eea75e7b4e96da1c79ab9805731f"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e28036e78119313b05947c16b65c5d512a97b96c1a096470c2c38877bd396954" => :catalina
    sha256 "dc47ed396c8a8c988d82b0a87f5c5c368d604f535ae5cc932ad941c22376073f" => :mojave
    sha256 "e45a0bec0801f7719539f0ccda6ce7cfc76dccd346d6a09bb65a04f2c2238cd9" => :high_sierra
  end

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
