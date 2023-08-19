class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c1e4264db7de66666c5ddd73b90d7aa32fe5e7afd8a2eb8fe781288e84f93f27"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb5c87ddeac8dc0f6f3e8af968db9b2063b2d74ec77df0f415b67c2c27898da3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adddcea0e3438970fe8966db87e6645e8c5ad637b232eb511653de0800f13d34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9817e8b6e248e9db23bd10db514522f09b28adc285c7ab3c72f0e4028bec912b"
    sha256 cellar: :any_skip_relocation, ventura:        "8e4377979365a134dbfe6ceb713986fb920c44ac101a8733a43b74bc6b597688"
    sha256 cellar: :any_skip_relocation, monterey:       "6af6516e2d93ccafae14ea25399d491ee2bb972a66d17370337f57781da8aa7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e97877cb970fac207f9389544f52977ac28cb526b911bb4ba76d6655b6e65a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a491cd9e012e1075c7f034cb53fd6c8c22c4d9f5baa8e4416b72b0e12b579099"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end
