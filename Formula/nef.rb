class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://github.com/bow-swift/nef"
  url "https://github.com/bow-swift/nef/archive/0.5.1.tar.gz"
  sha256 "0c4331c15aa73056abc20eadd2e400ef1c949c02a7ebcebb1aaf78b84deb5cc8"

  depends_on :xcode => "11.0"

  def install
    build_project

    bin.install "./bin/nef"
    bin.install "./bin/nef-common"
    bin.install "./bin/nefc"
    bin.install "./bin/nef-playground"
    bin.install "./bin/nef-markdown-page"
    bin.install "./bin/nef-markdown"
    bin.install "./bin/nef-jekyll-page"
    bin.install "./bin/nef-jekyll"
    bin.install "./bin/nef-carbon-page"
    bin.install "./bin/nef-carbon"
    bin.install "./bin/nef-playground-book"
  end

  test do
    print ""
  end

  def build_project
    system "swift", "build", "--disable-sandbox", "--package-path", "project", "--build-path", "release"
    cp "./release/x86_64-apple-macosx/debug/nef-markdown-page", "./bin"
    cp "./release/x86_64-apple-macosx/debug/nef-jekyll-page", "./bin"
    cp "./release/x86_64-apple-macosx/debug/nef-carbon-page", "./bin"
    cp "./release/x86_64-apple-macosx/debug/nef-playground-book", "./bin"
  end
end
