class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.2.1.tar.gz"
  sha256 "1773290791cce646e5e54e935118498a95948ca39ff5d58ac6dc65135275d3fc"

  head "https://github.com/chneukirchen/nq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f321a091c031ca3870cfd10844835ddbef55bd82c8c6ecf5275ae3323b9b4897" => :sierra
    sha256 "5ce475e389f345a2f1a0376a4253cf59672393f58b88e5a03b25f4c3c7d14ba6" => :el_capitan
    sha256 "1d6d53c0c53a230a600ee3be346c07625d7deffd2c134c46eb61d429d4392722" => :yosemite
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
