class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/refs/tags/3.1.3.tar.gz"
  sha256 "622bbb5c97f09b3f46ebea9a612f7470dd7fb6a7daaed12b87dee5af7a0177f6"
  license "Apache-2.0"
  head "https://github.com/kcrawford/dockutil.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f404c2ab7fcf02ede4213e5a5a81c92b27fd55c5e508bdb773a01e1bfe64c56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736b77305847eff297dface1a8e14f35e3c94fd8ce9a68efef0c6d4395abf1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b89b582646602f45c60de6737a65dc2b21d75393b2543d87be4754b89998e294"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d315729e980a1909812bcbf93183b6e745f9cd6ec6c253ac182af052235218f"
    sha256 cellar: :any_skip_relocation, sonoma:        "23624766ad896d382bf343aeb1b1c46d26f117a8928ab06e3cd3ad29437afacf"
    sha256 cellar: :any_skip_relocation, ventura:       "4436030a66f240ccfea5317023281dc817ce4bdf0784d52f0c90b536321be629"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/dockutil"
    generate_completions_from_executable(bin/"dockutil", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
