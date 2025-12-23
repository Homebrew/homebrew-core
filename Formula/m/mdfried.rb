class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "508039eb451c063b29890538c4519d1d82aa12ad4c975ad9a94fc07b049cc697"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a561140153257e96834ec255eb03cec50ae5b65a4806308ec8deeff66df703b8"
    sha256 cellar: :any,                 arm64_sequoia: "206bd1258fbc25e1a5745ef4ac24add6acb1d6d087fc9e6a987e03cf46462490"
    sha256 cellar: :any,                 arm64_sonoma:  "829aa6c72cfde616c35eb4ede6d73bad36db8fed804cdc8d7af43a007ef65266"
    sha256 cellar: :any,                 sonoma:        "cf5b7ccd81f0964bf1b22ba909b3eeab55b0ac5bdf6f733a80f1be06bb426c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "291be9d7b1db0146f21a184d8d2d4b241dae78f3bc6f618734d882690eda2440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6365b9d6b61594dc14400a888b0d1cfe0155c7b0c95eadb42e33df095ff2f7d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end
