class Mmtabbarview < Formula
  desc "Modernized and view-based rewrite of PSMTabBarControl"
  homepage "https://mimo42.github.io/MMTabBarView/"
  url "https://github.com/MiMo42/MMTabBarView/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a5b79f1b50f6cabe97558f4c24a6317c448c534f15655309b6b29a532590e976"
  license "BSD-3-Clause"

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
