class Gitfame < Formula
  desc "Swift CLI that logs your GitHub Stars and Forks."
  homepage "http://www.sabintsev.com"
  url "https://github.com/ArtSabintsev/GitFame.git", :tag => "1.0.0"
  head "https://github.com/ArtSabintsev/GitFame.git"

  def install
    xcodebuild "-project", "GitFame.xcodeproj",
    "CONFIGURATION_BUILD_DIR=build",
    "SYMROOT=."
    bin.install "build/gitfame"
  end

  test do
    system bin/"gitfame", "artsabintsev"
  end
end
