class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.20.tar.gz"
  sha256 "049a15670d63fcefb2f8581d09cf249ddfe9ad9fef908c9f30959f60576d8cc4"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5018ec69e6415a4671348a1419fe55ddd1a71ddb8a117073a085153e6a3c0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe479e614ac4174b7abf8b94f71236a0bbc9c0ccccc4d0505dd4ba1b366c98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b4819be8f42d8a3b7f751cf810ee171eb53335f5d87dd89f77df3bf9c9e9e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e72a73c18a9edc54b8e768590d47d5b07a2032cff0222c62060868b841c2785b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8744ba236b27300101606fcce3a1fd3bda415e8c97fdf624e96ed12df5e6d5cc"
    sha256 cellar: :any_skip_relocation, ventura:       "836db45715a94c06907146d840603e4f75b804563efa1030e4372b80d0a34547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9538108a7007c5f0d317cc15ef11ff213022f937e3fd2e3c5ae0e4ac7b6dd982"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
