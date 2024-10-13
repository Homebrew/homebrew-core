class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "6f6f2660fa917dcd2becd2bf1eb07a55a97b000beded278e9a31729c2e1607d4"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9971349107aa967e19ba88e18173e1fb95afc6aaf418b74a771c258d504a8309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed01ab6fa1864b006275ac541bd53468f6d297631697b5ce4c4a0622c8d6e6ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed01ab6fa1864b006275ac541bd53468f6d297631697b5ce4c4a0622c8d6e6ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed01ab6fa1864b006275ac541bd53468f6d297631697b5ce4c4a0622c8d6e6ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "e56b64110591e002a3b7a9e15c3ad476084dd1ffd9d51d867b902034d68acfe5"
    sha256 cellar: :any_skip_relocation, ventura:        "e56b64110591e002a3b7a9e15c3ad476084dd1ffd9d51d867b902034d68acfe5"
    sha256 cellar: :any_skip_relocation, monterey:       "e56b64110591e002a3b7a9e15c3ad476084dd1ffd9d51d867b902034d68acfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc68cb3135ebd1d3962e8bb5e3baa6e5f6fa744d3336ff3b0ae920b6dcc0f122"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit --version").chomp

    (testpath/"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin/"chkbit", "-u", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
