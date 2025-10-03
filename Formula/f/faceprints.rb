class Faceprints < Formula
  desc "Detect and label images of faces using local Vision.framework models"
  homepage "https://github.com/Nexuist/faceprints"
  url "https://github.com/Nexuist/faceprints/archive/refs/tags/1.1.2.tar.gz"
  sha256 "ce42a7b6d5f8c7fa8d4d11641f923e703f53bc01707991970923fd90b723d663"
  license "MIT"
  head "https://github.com/Nexuist/faceprints.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb178befed4a4d82d787f5e2e51c57b1b1ebdbfe3bf0ae87d3d9b5ea8209effd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d54d73d2266b3a81c863879ff51c1273fc77c0a280f091a8da8b493f40d70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a884b676b2b7ee86306ed95cb0c5e24eba6eac9822d08bfa33cdd5039e0399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "608a1e4d7c08361699340c37b1954f1373c4de557657863f3bf757bff148d802"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a902f4f04e39bce60a69fe10daab1fce1ee0279e43f51447718b4949aec1449"
    sha256 cellar: :any_skip_relocation, ventura:       "560c312597df4258d49e6410276021819721520474298fe5257a4772faee096d"
  end

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
      system bin/"faceprints", "extract", "Franklin-Roosevelt-1884.jpg"
    end
  end
end
