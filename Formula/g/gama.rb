class Gama < Formula
  desc "Manage your GitHub Actions from Terminal with great UI"
  homepage "https://github.com/termkit/gama"
  url "https://github.com/termkit/gama/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d2fad1280142b0cc8cb311a5e328590feb0c5a1642c47e3f8e0aaf1b713f6c7b"
  license "GPL-3.0-only"
  head "https://github.com/termkit/gama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733b2137013ca3a99db81a60d928e604309223613e98bdccd86e6c9368a7724f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9078cd53e0763f843729a0ffda3321354a6b664ffb2bed87e372e700cd9faef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9078cd53e0763f843729a0ffda3321354a6b664ffb2bed87e372e700cd9faef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9078cd53e0763f843729a0ffda3321354a6b664ffb2bed87e372e700cd9faef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8a11688f5d7cc46cfb8bdcfab4ec50a22bd17447ca4d274942270e2c671ed5"
    sha256 cellar: :any_skip_relocation, ventura:       "0c8a11688f5d7cc46cfb8bdcfab4ec50a22bd17447ca4d274942270e2c671ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ca6d3872fc83bcc8846dee1548dbfbb630df0d474f651a82f97e6798dcd537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104456f00e51024a56c6e94f32e471b1288925f7cbe4a568fe73f360379566dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # gama is a TUI app
    #
    # There's no any output to stdout (except for ncurses-like UI) or a file
    # `gama --version` or `gama --help` are not valid options either
    pid = spawn bin/"gama"
    sleep 2
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
