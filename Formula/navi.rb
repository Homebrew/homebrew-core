class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.17.0.tar.gz"
  sha256 "6de54da35cd6491c8a516efa78f0c866abc6eb2d81347d7faf6b905aeb443c95"

  bottle do
    cellar :any_skip_relocation
    sha256 "04a40559410f65f58cc1d9d19554d4413869583045e6b397dc4ae98041cca179" => :catalina
    sha256 "04a40559410f65f58cc1d9d19554d4413869583045e6b397dc4ae98041cca179" => :mojave
    sha256 "04a40559410f65f58cc1d9d19554d4413869583045e6b397dc4ae98041cca179" => :high_sierra
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
