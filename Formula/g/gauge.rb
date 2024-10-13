class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "86352bde2c2f44a0c4c67af615286fb91e06f5f4e8f41f5028e4f022527d9e77"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f07ca81e9aad6e50bea1f4aa32098f07ec4ee7b4cacd03364f8879a8ef5812e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36ba8ec0d766c3ea30f54761cc87331f11e0d533efdaf5bb4a2c9193c0b18b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25cef751c0ca4a5c7ceb63fd81c8355cca8524399f2531acfb8f7fa5013efca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "379b38593782ae12620480f24d1fa34593d298efe20989d5f87c44ad89774f34"
    sha256 cellar: :any_skip_relocation, ventura:       "c81ef92b30fdd20e6e6a2c889075aadb9a5cdc23f9123160084fae4c3765f2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9841915712f49294895cf1ef6187ed59d5a3c82de90f4c33e2561584f4a5b70f"
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
