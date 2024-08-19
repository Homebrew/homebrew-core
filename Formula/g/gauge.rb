class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "9cb2bce70a8170bef691e5f37571720aa402c896995d382fa5684eb91bb55591"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a31c62d74966ffb1770b18dd4c7f9a3f0147ebfb0a8ec6ef5aadf632880fb5bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5550ee37d4bdd8d357e22128c9fce747354dda001871ede450db29cce52b68a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "048063ae2da128eae5799e4878f45f46be9b2bb486b33aa80af8c0b82f4491d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7993b47d73249c86a68e12cbdef83c181518af74a8173993c1cb318da0cd94"
    sha256 cellar: :any_skip_relocation, ventura:        "3294fabd7b1e1ffdd724e79a40a6ba23ace32f13e44d2e9258c4b045f8baf89b"
    sha256 cellar: :any_skip_relocation, monterey:       "103af5651bb7cb965a92a4fd25148a5c7bda5ec8621906fe5b8c3587627c6637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2eb22978a70c3500d396c56960724e63d6d5f607dcc41ac1b84c2da1290586"
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

    system(bin/"gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
