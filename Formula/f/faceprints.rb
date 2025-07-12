class Faceprints < Formula
  desc "Detect and label images of faces using local Vision.framework models"
  homepage "https://github.com/Nexuist/faceprints"
  url "https://github.com/Nexuist/faceprints/archive/refs/tags/1.1.2.tar.gz"
  sha256 "ce42a7b6d5f8c7fa8d4d11641f923e703f53bc01707991970923fd90b723d663"
  license "MIT"
  head "https://github.com/Nexuist/faceprints.git", branch: "main"

  depends_on xcode: :build
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/faceprints"
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/faceprints --version"))

    resource "testfaceimg" do
      url "https://upload.wikimedia.org/wikipedia/commons/8/8b/Franklin-Roosevelt-1884.jpg"
      sha256 "048c91e6714608d7aade38be43ef18c60a8b6fd3a86e8abfd20af6751b042b0a"
    end

    resource("testfaceimg").stage do
      out = shell_output("#{bin}/faceprints extract Franklin-Roosevelt-1884.jpg")
      out_json = JSON.parse(out)
      assert_kind_of Array, out_json
      assert_equal 768, out_json.length # assuming dimensionality is static
    end
  end
end
