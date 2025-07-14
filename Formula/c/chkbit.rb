class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "7af5185a1db2efbec2e3f1e7fb26af2a6fe905c19caa59377ea495a71bc81b45"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6bd3e9f0e1782b5239cd3afe0bb894a30cff7a7566575f261771dbfe3fda2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6bd3e9f0e1782b5239cd3afe0bb894a30cff7a7566575f261771dbfe3fda2ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6bd3e9f0e1782b5239cd3afe0bb894a30cff7a7566575f261771dbfe3fda2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a6e6094b9841bbac174355d66c92b6cc614a0dde922f182a1314c68d884cf05"
    sha256 cellar: :any_skip_relocation, ventura:       "4a6e6094b9841bbac174355d66c92b6cc614a0dde922f182a1314c68d884cf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2661267a7ec58290b600b45ecbc4a66388035b4c8e1cc6c255fd81abc0efab"
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
