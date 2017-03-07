class GitFame < Formula
  desc "A Swift CLI that logs your GitHub Stars and Forks."
  homepage "http://www.sabintsev.com"
  url "https://github.com/ArtSabintsev/GitFame.git", :tag => "1.0.0"
  head "https://github.com/ArtSabintsev/GitFame.git"

  depends_on :xcode => ["8.0", :build]

  def install
    sh "xcodebuild -project 'GitFame.xcodeproj'"
  end

  test do
    system bin/"gitfame", "artsabintsev"
  end
end
