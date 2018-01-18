class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.6.0.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/chuck-1.3.6.0.tgz"
  sha256 "5a68b427c0caf63719a903c544244ddb67415889278f975234d58c7583ec34b4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "927a15abf98d767576584c0656688196e643ca9a15969b0e54e58bccc42f37f6" => :high_sierra
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :sierra
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :el_capitan
    sha256 "c34fd149bd7c3a419087f963ecea469b953b5eebd8099457fbf5ed2bb0876357" => :yosemite
  end

  depends_on :xcode => :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
