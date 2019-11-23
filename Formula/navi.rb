class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.15.3.tar.gz"
  sha256 "4b03693751a45ee078f62749df857f24fcbae7fe7b1c8a746bd11a79900a7e44"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6cc4ff602a50dde12f3b71e8463168eb9214821323205984c7831e918850081" => :catalina
    sha256 "d6cc4ff602a50dde12f3b71e8463168eb9214821323205984c7831e918850081" => :mojave
    sha256 "d6cc4ff602a50dde12f3b71e8463168eb9214821323205984c7831e918850081" => :high_sierra
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
