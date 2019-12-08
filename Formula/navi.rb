class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.15.5.tar.gz"
  sha256 "2ce8c7053fd5483c95d5b1be4a6cc02a7156c6f7e14d415d3d3b83011c2a37ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd03c825dba27feb53165a9fa193817d1a29eaab01333f109ed7aa1c14a30258" => :catalina
    sha256 "bd03c825dba27feb53165a9fa193817d1a29eaab01333f109ed7aa1c14a30258" => :mojave
    sha256 "bd03c825dba27feb53165a9fa193817d1a29eaab01333f109ed7aa1c14a30258" => :high_sierra
  end

  depends_on "fzf"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_equal version, shell_output("#{bin}/navi --version")
  end
end
