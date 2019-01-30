class IosCi < Formula
  desc "Build, Archive & Export iOS/MacOS app via command-line"
  homepage "https://tungdev1209.github.io/ios-ci/"
  url "https://github.com/tungdev1209/ios-ci/archive/v1.1.3.tar.gz"
  sha256 "cdd4696b707d035190ff306d0c5ea5467cf920873d8281531d03ebe4bd7ed897"

  def install
    bin.install "ios-ci"
    prefix.install "Author"
    prefix.install "README.md"
    prefix.install "hooks"
    prefix.install "config"
    prefix.install "helper"
  end

  test do
    assert_match "ok", ` #{bin}/ios-ci __test_cmd `
  end
end
