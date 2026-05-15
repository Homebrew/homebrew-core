class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.15",
      revision: "6a62575bcfdf4965f187eedafceb3400316e612b"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25910f57cce5ca973e4972f2d44981bd55028d76b0ddd44837f2b1d0dce67c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b6e23ed8e653d39237e6c1cffb7d428f04bb367b33f0dab9cedf11b3826633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3493252e80a1539e05f845ff8e33c291a5c8411d09cb81584d851fcec9d04564"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cec91e4e36257c85bdddcf97b30fe45ea97ea376dc56cc0bbe7b3fe90dd6924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494dbb05834b14a1ccfa9da555a9d09fa6b6b18081f13da4a520ee1dd1430611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba59c362169e2e8076262a2c663ca8c6a0f07510ca1098c3b15ce9513bc1239"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
