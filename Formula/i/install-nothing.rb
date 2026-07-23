class InstallNothing < Formula
  desc "Simulates installing things but doesn't actually install anything"
  homepage "https://github.com/buyukakyuz/install-nothing"
  url "https://github.com/buyukakyuz/install-nothing/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "de1afd428496e8d7228e2023104613098808994b0c3859565fd02d41e86928f9"
  license "MIT"
  head "https://github.com/buyukakyuz/install-nothing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87f77b50975349223e18f63a0d1de03cbaef86db5711dbef0d1c166708ae9226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d032123d0201bb3e68ff634399e98770bef3ae3625fe28d5a2a7bdee13d221e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b086e4a01e79d85da4989e2cc748b637b9457fe324aec2252fe4a191a8e03c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "e17602aa9e85136ddf3758f10012d34ba13e39baab9241d0e826f8e224a97acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d24c153d233b51da3858f8cdd14faa7fd71bb1bc9cf8258f0f985905f51f9eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93db2ef7a614641d659738c9b2b7c15978bc00695e8aa46b08351e6c8dfbc458"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, ps://github.com/buyukakyuz/install-nothing/pull/14
  patch do
    url "https://github.com/buyukakyuz/install-nothing/commit/1933dfd5ac5f8e6572b6cb0d8fde8b152fb51540.patch?full_index=1"
    sha256 "11ffb9c283c1d38933de854468b2f6c6001aa5d4886961a7372dde3ea602d44d"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # install-nothing is a TUI application
    assert_match version.to_s, shell_output("#{bin}/install-nothing --version")
  end
end
