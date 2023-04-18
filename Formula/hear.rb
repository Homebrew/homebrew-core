class Hear < Formula
  desc "Command-line speech recognition and transcription for macOS"
  homepage "https://sveinbjorn.org/hear"
  url "https://github.com/sveinbjornt/hear/archive/refs/tags/0.3.tar.gz"
  sha256 "671982c2361e636c79c5118684f73df2d0f282461e128ea0dc6034165819c520"
  license "BSD-3-Clause"

  depends_on xcode: ["9.3", :build]
  depends_on macos: :catalina

  def install
    mkdir "#{buildpath}/dst"
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}/dst",
               "-project", "hear.xcodeproj",
               "-target", "hear",
               "CODE_SIGN_IDENTITY=",
               "CODE_SIGNING_REQUIRED=NO",
               "CODE_SIGNING_ALLOWED=NO",
               "clean", "install"
    man1.install "hear.1"
    bin.install "dst/hear" => "hear"
  end

  test do
    system "#{bin}/hear", "--version"
  end
end
