class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "41a20de21e6a57942ec4e41b049babe8dac77b246a0549b87631cee0d2e75b2c"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf2ba2781373eb73d5f88f75a767247e6f5c2616ac0ade1aa7c0c1d328caacb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a2288561a8a6de92ee951d518edad122b911cfc80e7096ecf6176c71c47cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c9f85079330c13bad738b9858e5fbfee18389a1bc3e37521fe258be79bd2aea"
    sha256 cellar: :any_skip_relocation, sonoma:        "25af43efbb66b9ede19cec145c887ace7e22f8ebb58d136c75dab132df1c0ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb203ab546e0e68a686c9a9987939b2d4b7fed96ae37644dc512e3709426b17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34188e33e1803f66e92436ee948f5d429b1809cb9d8218f134bc4d1a7be29ffb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
