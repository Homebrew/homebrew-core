class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.1.tar.gz"
  sha256 "26fd8500334118c2eb3910ea9fa8fbd955aace59209cedf01179b29c072290fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4174c819609e1c263abd35cb2db17ee14925387ae27d6c4319b51d02af6a5043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23b1615eff284371cb6fce07aa987bdb1a162d9bb8d31f91ad2a354acf6f13b9"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9ac58de42c1a600af3df0b170219ad5590ce2d0f0ac0238c3956a65698d683"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6507f6a442a0890618d98a4b1cae5698c674753f895a5b54fe465ebeaf2f3c"
    sha256 cellar: :any_skip_relocation, catalina:       "8ba42e63a7089b339cf1438304a096e39e0c32f0d7308306837a2b489422e0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03036ad720e2948b071c6f97d26cebf7e37aa1c3dfdfb99238f5feed05e1d09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
