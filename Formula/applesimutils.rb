class Applesimutils < Formula
  desc "Apple simulator utilities"
  homepage "https://github.com/wix/AppleSimulatorUtils"
  url "https://github.com/wix/AppleSimulatorUtils/archive/0.5.1.tar.gz"
  sha256 "2dd3f5800c991d49c84b65b07f21b6a34bdb0e056bad5820ab1d9381e2f7758c"
  head "https://github.com/wix/AppleSimulatorUtils.git"

  depends_on :xcode => ["8.1", :build]

  def install
    system "./buildForBrew.sh", prefix
  end

  test do
    system "#{bin}/applesimutils", "--help"
  end
end
