class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.7.1.tar.gz"
  sha256 "0734b86d48291749ba2537fa6c03e4c3451628f630055c877789e0346db8d67d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ac2fc52c2967468cd727ea1ddc9083f39210882d0f3f2ce41cfa68a47a083b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "6647269bec6a937e78224010ea51c25573103e3c2357c186dc44f230cb31dc50"
    sha256 cellar: :any_skip_relocation, catalina:      "d56a6e6c6b36044cd7c1e120bc17abfd52903cc1cfa5a29afd1f0945245312a4"
    sha256 cellar: :any_skip_relocation, mojave:        "95589cb592c41dc1187d43b148962ad0b24fe0e8278438205654e17f4786d1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cbbeb8a43d2429cedf0c7d9cd77cfbe9284f763dcfd377311cce3cab186ea7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"dlv", "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
