class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "99a69e05172ed27f0cf60d4aa967bc3f00a34f49c0d6529f6df41242cab789f8"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa3de15f0dd07551bfcd3e36a3b228cf66332893fca929b4dd37869b03ab8f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa3de15f0dd07551bfcd3e36a3b228cf66332893fca929b4dd37869b03ab8f37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa3de15f0dd07551bfcd3e36a3b228cf66332893fca929b4dd37869b03ab8f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "45d20ff4444e1f13ebdd46bf0f85397c7c49abc79e9a54d99549bd960b0c5e85"
    sha256 cellar: :any_skip_relocation, ventura:       "45d20ff4444e1f13ebdd46bf0f85397c7c49abc79e9a54d99549bd960b0c5e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be986d6bf7eb3637f5d9afdf6ddc904cbd21d4c67af7e76df8bb4edcb4bf7d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_path_exists testpath/".chkbit"
  end
end
