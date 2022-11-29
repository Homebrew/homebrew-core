class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.9.1.tar.gz"
  sha256 "90066e7b984a75a9958360c58dafa0d9b9e44753f27b1c36ee74144c8585f311"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20a2f68691ee343bdc9eb913f8699059151eec9db869ed73f2fbeef622ff684e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b022a92cb2cc5b8762a898a41bf496486c562118afb90422d9437a30a403f1cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42591b439f40cf1039e2535e35471be7a088240a83a0d3326eab194a79358040"
    sha256 cellar: :any_skip_relocation, ventura:        "e3ad23b5052b40c5cfc05e91e252f639936981f443b0a1cb6283f3942bcff8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "546c6c2476568602efd7ea100e2d341c7daf49c438194e8be80e84e6be5ae60a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9592075aa0a634806d6d9f7ce7890dd05eb7291bcbd89995e07b9bf741f3c832"
    sha256 cellar: :any_skip_relocation, catalina:       "e51ec8f106813d9e8e43e4dd719a579e75e2f4384ab50880b6fb08f58889f740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef9952ec5cc037f6a41034429d076d77acaa1aea8893cc4506c3f34f6b8f01f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
