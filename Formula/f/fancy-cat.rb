class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0025dfb6c06da0d5495e9c70d6955cb6d2e3a9b2f72a0c83737e7bf17c6abfde"
    sha256 cellar: :any,                 arm64_sequoia: "0cecf82a7ba9c45ced1dc1f274eac9af50f44f58b771d88be39cb0ad51abbd02"
    sha256 cellar: :any,                 arm64_sonoma:  "f4a3682131b057c04cd5bc93d431112ea14d8643bdf62b9787618df198999097"
    sha256 cellar: :any,                 sonoma:        "d1083731fb06f573f6bf0642c5fe482c2270ccc7c03a9ff523bde8f71542f26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65273d8e7b5f029c2a84d8d681b58f8ed9815b9d5f4a951a954380650c4f7259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d32032d0e2c7cf4f0eaf5dfaf7cfceb684795311dba108180b6261b6b37e6303"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
