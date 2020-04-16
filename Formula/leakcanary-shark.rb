class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v2.2/shark-cli-2.2.zip"
  sha256 "4d8aaeb68e2783217267109f5d0c7bcafc78607b54b248e3f3214c07777fd278"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Usage: shark-cli", shell_output("#{bin}/shark-cli").strip
  end
end
