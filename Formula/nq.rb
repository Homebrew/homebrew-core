class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.2.1.tar.gz"
  sha256 "1773290791cce646e5e54e935118498a95948ca39ff5d58ac6dc65135275d3fc"

  head "https://github.com/chneukirchen/nq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "628282013a47d803037a67425f45ffae15d981e970e1f460854359a9aa124f35" => :sierra
    sha256 "338e55ded1d9d3ac8c2efdb97a8ccd0832ff5a84d1c90937a6c1f23ce6426518" => :el_capitan
    sha256 "a85312b7a2ed7cfda110cb1b7c5e2cf5bd9a5eb87b2597a33e6b6a30f3c6c395" => :yosemite
  end

  depends_on :macos => :yosemite

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match /exited with status 0/, shell_output("#{bin}/fq -a")
    assert File.exist?("TEST")
  end
end
