class Mmtabbarview < Formula
  desc "Modernized and view-based rewrite of PSMTabBarControl"
  homepage "https://mimo42.github.io/MMTabBarView/"
  url "https://github.com/MiMo42/MMTabBarView/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a5b79f1b50f6cabe97558f4c24a6317c448c534f15655309b6b29a532590e976"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8d752b1a6566f010c2a3c42c7248e56e15ea8c55b80a7cd6b7fc571b67f81912"
    sha256 cellar: :any, arm64_big_sur:  "10a139efa381ffffb4b38609246914c123559b80ceaf16baa96135ae4687ba5b"
    sha256 cellar: :any, monterey:       "83aa65e0eaa1ee040131cda4ec9f9c1447ebd06124b7680c754a6c6ed8786d01"
    sha256 cellar: :any, big_sur:        "a16676e466f896888d2e90cc703dd95919b242bcff90ae84d4c5be05eee3b881"
    sha256 cellar: :any, catalina:       "3ef5d2b3664b7ba3def8ba27c4b3c2e5d94af4f5da6aee0400fd148b091e955c"
    sha256 cellar: :any, mojave:         "6ce9ac264e1e62f9ee98dd08e6837def238b99c3a5506cc0c470be4c5442ba3e"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-workspace", "default.xcworkspace",
               "-scheme", "MMTabBarView",
               "-configuration", "Release",
               "SYMROOT=build", "ONLY_ACTIVE_ARCH=YES"
    frameworks.install "MMTabBarView/build/Release/MMTabBarView.framework"
  end

  test do
    (testpath/"test.m").write <<~EOS
      #import <MMTabBarView/MMTabBarView.h>
      int main() {
        MMTabBarView *view = [MMTabBarView alloc];
        [view release];
        return 0;
      }
    EOS
    system ENV.cc, "test.m", "-F#{frameworks}", "-framework", "MMTabBarView", "-framework", "Foundation", "-o", "test"
    system "./test"
  end
end
