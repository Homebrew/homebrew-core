class Bumblebee < Formula
  desc "Read-only developer endpoint scanner for supply-chain exposure"
  homepage "https://github.com/perplexityai/bumblebee"
  url "https://github.com/perplexityai/bumblebee/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "559a5fa9ca48128fb113644e7800048b0b6c2ff3a33bc56fe5236582ba1686b0"
  license "Apache-2.0"
  head "https://github.com/perplexityai/bumblebee.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fca2487780ec10950f973b94c747cf243b100a52c34d1099c6c675930a5712e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fca2487780ec10950f973b94c747cf243b100a52c34d1099c6c675930a5712e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fca2487780ec10950f973b94c747cf243b100a52c34d1099c6c675930a5712e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86f50f0a53373452b8e152dcd5dabac8cf2b4e81cd744cc396fafdb78fb1c0fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b484194ae4f54898f47a2bf797b086048e36022d6e3c2ef6ddd2f86bcd6721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda1d4525da9b234e1243ef703916c830be214e18d2abb34536622b87dac3965"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bumblebee"
    pkgshare.install "threat_intel"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumblebee version")
    assert_match "selftest OK", shell_output("#{bin}/bumblebee selftest")
  end
end
