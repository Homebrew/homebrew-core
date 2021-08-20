class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.4.1.tar.gz"
  sha256 "833d8d8b395b566ee94ed957dd2a9564b9a11eabe709338db02c1c8c0ee3b637"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ea86ebd8862c1e43ad136df5f06e3468c7eeeaac8abe4b322f74e79467a3928"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5c5de95e30c97fb49d97360aafe1a3b84615a7a5f091fa794cc8e50c17fae95"
    sha256 cellar: :any_skip_relocation, catalina:      "8c2e9ae82bdb314e93798356d05e077374e783d517132a90622fb712dd8d770d"
    sha256 cellar: :any_skip_relocation, mojave:        "c1c37c68fdd18a382b2c4e3d6114fa9a658edd6c7ad802f437189e30bde09f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53218e3981d09b19b2729da95bb018a3a6d407bb59c1216d9382360309a1e2c5"
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
