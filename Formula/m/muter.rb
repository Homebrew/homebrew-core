class Muter < Formula
  desc "Automated mutation testing for Swift"
  homepage "https://github.com/muter-mutation-testing/muter"
  url "https://github.com/muter-mutation-testing/muter/archive/refs/tags/17.tar.gz"
  sha256 "97076ae62d94670f4547d576f70ddde7f9933c34bee320ff6c5cc664c25af23c"
  license "MIT"
  head "https://github.com/muter-mutation-testing/muter.git", branch: "master"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "muter"
    bin.install ".build/release/muter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muter --version")
  end
end
