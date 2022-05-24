class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.3.tar.gz"
  sha256 "b18dc56de8768da055125663e7c368ecf24cdac4d72d9080ac90dc0ee99ea852"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b720568f637be12d53df29d522d11c3e7b0546e791018eb0da3add0ed3a57a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29ee4f9b5cfe792613ecc573c62a8efb1a1d43df4269d1d8e37b50281d2cc3af"
    sha256 cellar: :any_skip_relocation, monterey:       "58bb09993b98b4bea8c784528a92d2dc0c87c6a20fcf410a6ddda08fa70049cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0002b2139626394d7e94e847f93c343c4e6b99b1081e1e481256ec409723d03"
    sha256 cellar: :any_skip_relocation, catalina:       "e29480e198eac7d9a6f7ce9db4ba5c84547e36d4875c1cfcfdd2d196c607cb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd20c580621457329e18d968e040530ef54bb61d5f3cbceacf346c80a8a89f15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
