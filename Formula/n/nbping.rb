class Nbping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/NBping"
  url "https://github.com/hanshuaikang/NBping/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1a73f125601cac5ddc456b15d58b5145b859c46da24ce2024288fe4343050e5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6027aa61b2d10461ee2e064be0b233e8a9940cdbe9799093e8fee3f21861acf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fd281acb289638ed17e4a1b5ecae853a42a0e341df00b90427c25004d068aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dfd2f512be1b7cc9787fddcf5d9a08713d88a576c1147c22f18e33642589911"
    sha256 cellar: :any_skip_relocation, sonoma:        "53efa2a79664589ca6993e1bb42c4bdb1b255c6b055c3beb79c8ed3b91c3f724"
    sha256 cellar: :any,                 arm64_linux:   "66b75bb0513e38adb7ee3483ad97d30ed5728a0783db61526ee4385714aa7226"
    sha256 cellar: :any,                 x86_64_linux:  "927c17ec1c17ae1e63080262ea7715aa90a0ce8b06f41861305660af23b272d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nbping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nbping", "--count", "2", "brew.sh"
  end
end
