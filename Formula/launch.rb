class Launch < Formula
  desc "Command-line launcher for OS X, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.3.tar.gz"
  sha256 "b4bedaa61f7138f9167e7313e077ffbfc0716a60d4937f94aaedf3f46406bc38"
  head "https://github.com/nriley/launch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d0ed8234a311087444d64a43fcc0bf1db1457a7ffe0668742988e8bcbdccfe1" => :sierra
    sha256 "37aa828b39694007f7a75b86b2b1cb184513c4a150bb2aae5ddced1fb0c21444" => :el_capitan
    sha256 "2d5b91633648f62313ae9aa36b3d30ec3b057ec4c5a9eb63d43f2a63c49d825f" => :yosemite
  end

  depends_on :xcode => :build

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    assert_equal "/", shell_output("#{bin}/launch -n /").chomp
  end
end
