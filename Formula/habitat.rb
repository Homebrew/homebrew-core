class Habitat < Formula
  desc "Application automation framework to build applications"
  homepage "https://www.habitat.sh/"

  url "https://habitat.bintray.com/stable/darwin/x86_64/hab-0.7.0-20160614231131-x86_64-darwin.zip"
  sha256 "93fac880261df34c75ac5775c9febb536b82ac955cd6df873bbfec1cf697ed50"

  def install
    bin.install "hab"
  end

  test do
    system "hab", "--help"
  end
end
