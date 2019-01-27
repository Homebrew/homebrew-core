class IosCi < Formula
  desc "Build, Archive & Export iOS/MacOS app via command-line"
  homepage "https://tungdev1209.github.io/ios-ci/"
  url "https://github.com/tungdev1209/ios-ci/archive/v1.1.2.tar.gz"
  sha256 "31d8c7313d7f49fe99df0fa390a4496aa9a178e1ad8c12657951e38063796547"

  def install
    bin.install "ios-ci"
    prefix.install "Author"
    prefix.install "README.md"
    prefix.install "hooks"
    prefix.install "config"
    prefix.install "helper"
  end

  test do
    system "#{bin}/ios-ci", "__test_cmd"
  end
end
