class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.14.2.tar.gz"
  sha256 "1e16b8ff440882a2dd8e73bdb55c2b88724b3f0f9844c602ae9fe74f509d0dfb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e63e48d419cf40d0e37ad5b877a24fba25bbd0e7da35fd48648b6d039266363" => :catalina
    sha256 "7e63e48d419cf40d0e37ad5b877a24fba25bbd0e7da35fd48648b6d039266363" => :mojave
    sha256 "7e63e48d419cf40d0e37ad5b877a24fba25bbd0e7da35fd48648b6d039266363" => :high_sierra
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
