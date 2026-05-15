class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "7dcc439e32a6b1723b7809175eb43856b7817899350bbf47f794b1103dfec69e"
  license "Apache-2.0"
  head "https://github.com/energye/energy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a27c25d9ad14623bd9965a490f8fa9b8c8f1752ae317f2555b3512bdb9322432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a27c25d9ad14623bd9965a490f8fa9b8c8f1752ae317f2555b3512bdb9322432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27c25d9ad14623bd9965a490f8fa9b8c8f1752ae317f2555b3512bdb9322432"
    sha256 cellar: :any_skip_relocation, sonoma:        "015ff3808a131a703cc0a7e492a77a9111cbbc2b30e524d80ef5a59fb27beac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5d3cd5d47b2d5968e96a2446412cd22430b344f455db80e7918230720e8bc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5dede6e5a0d45f8785b7b0d3fecdd443f7d5bab5195e74e81608edd7c7fa690"
  end

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/energy cli")

    assert_match "https://energy.yanghy.cn", shell_output("#{bin}/energy env")
  end
end
