class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "625913da6d402af5b2704a19dce97a0ea02299c30897e70b9ebcee7734c20adc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, ventura:        "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, monterey:       "391c16733d7103416777eec7a8d3bd53ea6df60c2ec1224ef298301bda0d4f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef9b376256dcd98aea51b20d2e8c85645b0286f599aa1b21b4d70feacc1651c"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
