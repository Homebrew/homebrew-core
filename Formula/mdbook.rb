class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.21.tar.gz"
  sha256 "17385837070c6a312eae4717fe0bfdd259ce07b4b653b5c258b4389062df886d"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a3792b6cad823095df8d5d301038e7bf9c4a33f373d715f3357c72155100ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8354a7e89d56dbce1fd5d59f2c51cbdbf3da90e8067f121ecaa28c753de0f24"
    sha256 cellar: :any_skip_relocation, monterey:       "dfb4d4aa948ac59bf00479aa3f7cb98e584f5c9318753949653feefae906a2cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "92eef5eedf66ee9927bea9a7b4c28e634c6b76d922bf303c63d0a1f36e77423d"
    sha256 cellar: :any_skip_relocation, catalina:       "270b5fe29ec50a55adc358c87fee18dd8bd2802cff2dc4f480f36d1d923f3e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb16738a148a8a4b95008aba3400e721c6540b300aa280088dd6478c10d90e6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
