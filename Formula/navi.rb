class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.15.2.tar.gz"
  sha256 "984b978f7d2803b5d2a66866b1df61021610f641b81c4196e23108c1063d9d09"

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
