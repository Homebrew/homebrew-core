class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.4.3.tar.gz"
  sha256 "0c4feec0af5367ed5000060847442ca4d72db7dfd9fbe5e0662cd520d9f5c489"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0db6b7cec9d88fda8d84a43bc5aab56c077b39ad44f2b955f606213798fe1fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff56b7d4f17e14d2ae02dfdd770666f5cef75c6bd4213cae97ce776a3786e7f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18070f4e1d911da06a76b7012271c85f4f655bc868b402f02c421ba16f08c259"
    sha256 cellar: :any_skip_relocation, ventura:        "05117bb3c0b2efeafe41e817cd3ad86307c1d2ea7e0e835655c4b51ab2472893"
    sha256 cellar: :any_skip_relocation, monterey:       "a908209b3fa35a66e42b0601a861ac4f8ab2f5ff50541b84d6f4c570598fbb7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e7475fb10a5cdd370d5b46b75882491e4a5fc9d9d35f671a8bfa685ce58c7a5"
    sha256 cellar: :any_skip_relocation, catalina:       "17d77e9164aeab8f0c2ddb3c7333ed2e9d1d73f4fe8f9e21b87f42c811cfc75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd952c55616d2c1a06dd0e41d4dac4c47bb56bc78121058cb861075ba048dfb7"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
