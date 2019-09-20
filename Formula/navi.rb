class Navi < Formula
  desc "An interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.5.0.tar.gz"
  sha256 "8ca49b7032277f74244e737edd1a4fe2f296918cdd3d00c0734c67b4f1649ff2"
  
  depends_on "fzf" => :build

  def install
    libexec.install Dir["*"]
    bin.write_exec_script (libexec/"navi")
  end

end