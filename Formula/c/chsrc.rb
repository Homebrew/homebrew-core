class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://chsrc.run/"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "0c1ff6ec9e8860d6c0455bc2f0e228647e578fbbe1874141850ec253a9693f10"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7f90c25de6c9f97b35d02a8e13ae0fd92a55dec3325a17a27af4fefd281be8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d608a1cce2b8e7fc7fbbaea8ddd3d277cd00e25d3c381bad28ab82259cf96c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b439a709ecd0c47ccc6230f64b777fd25358bb648f2bcce97d15e797eb3f7ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a23c1fe921358ab41fa784cd89561e7d76d6557110b3df996598b70d3ce1ea"
    sha256 cellar: :any,                 arm64_linux:   "edc2e8809f8a0ed9424a92048b78d42fc1b57df1f1ab1569560a0b392c225969"
    sha256 cellar: :any,                 x86_64_linux:  "34a2da1cd4b1ca1ae81556b7eda7f9e7da37ef6160b7999ccec37dc0d87fcf0a"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
