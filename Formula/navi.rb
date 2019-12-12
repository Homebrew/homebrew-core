class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.16.0.tar.gz"
  sha256 "38f2fa3ec2198bf4ce0dbafcb244f845581fd33153dcc3007fcc5ff0585c59ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :catalina
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :mojave
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :high_sierra
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
