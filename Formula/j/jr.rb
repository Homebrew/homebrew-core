class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/jrnd-io/jr/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "82d8e554724cdba39fa5f976f56422b9eb119644ec9de5a3e12a670eefb67bdc"
  license "MIT"
  head "https://github.com/jrnd-io/jr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ede79e8ba3c27bb0ac90e9818db7f18bdbe48d84195ed9b6f81930013e2c9564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8caec91e5e875f6d4afc1cdc07fee8258594ac4d4e5f4827585735dd9b259d2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a96de687b0e3d6c49772ca0cf573afdc00fb0abd18fc6524b5f7ef03efff936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "725f7752c78b6c3c923c69f8483b83f82b1ba5bdcb9945212e5f5f69213733c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "dedd73305310549a6f1856239ffc9c51da3530ca3c07467798d8a9bdc70fb190"
    sha256 cellar: :any_skip_relocation, ventura:        "7e1f341676b064107654969708cf8a99c9ee75a050b5d36b58fbfcfe10e75fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "db3da339cd6feab3abdba0b0d694d989ffa2b67f751fe6430bf2bbe4ef08f883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556c4cbe64419b781749b6e4cd8413b35c17e9e15d7ca8d7f054d121ee6a1be5"
  end

  depends_on "go" => :build

  def install
    ENV.deparallelize { system "make", "all" }
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_SYSTEM_DIR: pkgetc
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
