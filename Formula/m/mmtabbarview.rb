class Mmtabbarview < Formula
  desc "Modernized and view-based rewrite of PSMTabBarControl"
  homepage "https://mimo42.github.io/MMTabBarView/"
  url "https://github.com/MiMo42/MMTabBarView/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a5b79f1b50f6cabe97558f4c24a6317c448c534f15655309b6b29a532590e976"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "a502f7deb3e18188669316c46c503980256b4286d0c52d1e211a772d45919844"
    sha256 cellar: :any, arm64_sequoia:  "9ae9758b04f5cbc6068b0e41266db2fbad7065d90134060c27bc73d36d780c2d"
    sha256 cellar: :any, arm64_sonoma:   "4b4fbe5492b90614b36b8a99101acbd15b0b9ebc4b415683c273114e47d3e1cb"
    sha256 cellar: :any, arm64_ventura:  "ec634de2a8f60f6d6d09c88cc8ce9293fd94ee07ba2181a7b07a3ee2f29d99ac"
    sha256 cellar: :any, arm64_monterey: "8d752b1a6566f010c2a3c42c7248e56e15ea8c55b80a7cd6b7fc571b67f81912"
    sha256 cellar: :any, arm64_big_sur:  "10a139efa381ffffb4b38609246914c123559b80ceaf16baa96135ae4687ba5b"
    sha256 cellar: :any, sonoma:         "f6fcf8f6b9069275523c824545c19a90f5dc31170531ea727181476f21d62fc2"
    sha256 cellar: :any, ventura:        "d7029d1e75a1a3e9fe45c92c67203ac9de958bc22b52193753db670484d31540"
    sha256 cellar: :any, monterey:       "83aa65e0eaa1ee040131cda4ec9f9c1447ebd06124b7680c754a6c6ed8786d01"
    sha256 cellar: :any, big_sur:        "a16676e466f896888d2e90cc703dd95919b242bcff90ae84d4c5be05eee3b881"
    sha256 cellar: :any, catalina:       "3ef5d2b3664b7ba3def8ba27c4b3c2e5d94af4f5da6aee0400fd148b091e955c"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Apply workaround for Sequoia based on ViennaRSS fork's fix.
    # This is done via inreplace as pathname has spaces.
    # Ref: https://github.com/ViennaRSS/MMTabBarView/commit/149fd82953a8078c4d60ce3fa855a853619eb3f9
    if DevelopmentTools.clang_build_version >= 1600
      inreplace "MMTabBarView/MMTabBarView/Styles/Mojave Tab Style/MMMojaveTabStyle+Assets.m",
                "@import Darwin.Availability;", ""
    end

    xcodebuild "-workspace", "default.xcworkspace",
               "-scheme", "MMTabBarView",
               "-configuration", "Release",
               "SYMROOT=build", "ONLY_ACTIVE_ARCH=YES",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    frameworks.install "MMTabBarView/build/Release/MMTabBarView.framework"
  end

  test do
    (testpath/"test.m").write <<~OBJC
      #import <MMTabBarView/MMTabBarView.h>
      int main() {
        MMTabBarView *view = [[MMTabBarView alloc] init];
        [view release];
        return 0;
      }
    OBJC
    system ENV.cc, "test.m", "-F#{frameworks}", "-framework", "MMTabBarView", "-framework", "Foundation", "-o", "test"
    system "./test"
  end
end
