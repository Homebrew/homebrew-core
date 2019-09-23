class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.8.1.tar.gz"
  sha256 "fb453cddb7c15ffdabe62a88f80948b9335fc6dbe79547ed68dbc55236d241ee"
  
  depends_on "fzf" => :build

  def install
    libexec.install Dir["*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_equal version, shell_output("#{bin}/navi --version")
  end
end
