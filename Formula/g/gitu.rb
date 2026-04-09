class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "eba1cd649339ee1c6f02c39bcd9fc3092df8e374bfbcd194750a966b09cb5e55"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e26a16a99458e8ba03255708da91ace7d2412990bbaa07f406ace1832a10c312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64139abb25b6584ac88caaee6ec40ec0d7897b6c3e806f723216bf79102d2cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a8f3f9192d82ad1ae655e43334fb65015a9203c27cabe05ca85fa879c5392e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8756d20bb8aefc83f82b9f1cdb99b77df4c5426857bee2e3cc5c2291e7b0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934a83b1dbf1b243fc07cd615cf14caba3254e468ec9bdd0d137f13f726f56c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56115a186420b966d1ebb0c245d6c7ef552dc16c93da418e568b3c47e4296907"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
