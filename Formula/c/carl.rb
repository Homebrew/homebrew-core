class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://codeberg.org/birger/carl"
  # Missing codeberg tag, use crate url instead
  url "https://static.crates.io/crates/carl/carl-0.6.0.crate"
  sha256 "225a66d6b91fc6fe15ff1a7afc9f8c1d461f2885aa9a115e06947d3d81f20da3"
  license "MIT"
  head "https://codeberg.org/birger/carl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d21a990f8c5f3931d93da22faf9d36b3b6787ecbad375d8320a036aeb8594ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d47ce1462ef9d2611a7733caecf43ffcd219d4a331b2344696ee629ebe0a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12768bb6c7cfb482daf53ccc37f39649111c7cb58cc897ecd8c31c7212a1ab3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0fa83c64070ed3f6a1054a8746563c3491d161dbeccf9e37e4607cc79923c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5d69dca7889f030c6b7afed336096ca34277f0507fa979a6f1ecaec0a37b998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6a9bdd2525af6219b9ab3ad7e424c4996e17769cd4acfdaa1e4d7b04090e43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end
