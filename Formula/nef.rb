class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.6.0.tar.gz"
  sha256 "a67bb4201739898832ec52e92d838ccfcae25a490df433cd7cf44f1fc6e0a786"

  depends_on :xcode => "11.0"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exist "#{testpath}/nef/resources.md", :exist?
  end
end
