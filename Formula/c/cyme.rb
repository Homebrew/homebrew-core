class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3db71b9c75b87bec10283d97f298e930ec258abe1d669de5a2f99c390f20c73f"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "629dcab85400cb46089b4bcb0204fe7beb7eb613fcf3e5277f5dad5515eba65d"
    sha256 cellar: :any,                 arm64_ventura:  "073f85d79fc2e7f6de59d17cc4f536444eba9c72f91583351da9c7d3b778e9e8"
    sha256 cellar: :any,                 arm64_monterey: "4df5a42e4254338f2e86e0efb12982729e973717df78f409d2b1f430ab2ff193"
    sha256 cellar: :any,                 sonoma:         "aa6eac1ee2bdc28759945a8a0eaf5da71634513998c6a6c7145cc20726c9a205"
    sha256 cellar: :any,                 ventura:        "caab5b29000428fcb1b09a1069702bf025494b5840910953257958ddef80b3ee"
    sha256 cellar: :any,                 monterey:       "915631f372f85aad0568a622f34285ad859ae2d31ef155599da9a2c6c596c921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f812e06dc0cc5df99ac7cdb44470827b10da88f73530f7682380e4259d83bd93"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
