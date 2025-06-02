class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.21.tar.gz"
  sha256 "3ddf2798ab1853932ecadfb1bcc1ea6cecfb96fbda35fbd52a797baf5844e6b1"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681743141ad4722b7161b6f11c6f513d4c5844ee51f25ba9f5535c85ca0eb64a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681743141ad4722b7161b6f11c6f513d4c5844ee51f25ba9f5535c85ca0eb64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "681743141ad4722b7161b6f11c6f513d4c5844ee51f25ba9f5535c85ca0eb64a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c53ec508dd9962b23efba69a2948eecd0400a8468f571b869a4184c51f0e93cf"
    sha256 cellar: :any_skip_relocation, ventura:       "c53ec508dd9962b23efba69a2948eecd0400a8468f571b869a4184c51f0e93cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d1afdfcec69c42387a91aeebc377b0c7709e4fbfdf5a990362e852a598e417"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end
