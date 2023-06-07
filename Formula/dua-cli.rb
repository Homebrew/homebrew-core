class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "05ce2d74ec1282803c6825b0436d8b268eef176060b844ae29746a3d338fe658"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55e886006366e0bbaf87b741d782997cff53779204060d772fa641104a0f4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e45562d2303c72404e917d6ebd21d45e08e92da458fa7e31bc92503f158d1cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "911dece14e16458500f806ef74be1f22fd9bee50e6ecd9b48f8eb02953a67843"
    sha256 cellar: :any_skip_relocation, ventura:        "df03bc090641f93dc0c122dd6e323183af61c8c7e1b0fa50f7ee7792b6117ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "c58a5d68db3faa7d3b29049598c0967202e08bc68fa85bc3efdfaa2b97983776"
    sha256 cellar: :any_skip_relocation, big_sur:        "18ed6f07fc379d000cb96ac204e7f0e1249ca8a69529ad8ca4abecb731b7e0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44dff7181ddb90c892a558ceadbd44eae2c65d6e8738be65e7798dca0142bd55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # upstream discussions, https://github.com/Byron/dua-cli/issues/163
    # need update after this PR, https://github.com/Byron/dua-cli/pull/158
    expected_macos = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    expected_linux = <<~EOS
      \e[32m     0   B\e[39m #{testpath}/empty.txt
      \e[32m     2   B\e[39m #{testpath}/file.txt
      \e[32m     2   B\e[39m total
    EOS

    if OS.mac?
      assert_equal expected_macos, shell_output("#{bin}/dua -A #{testpath}/*.txt")
    else
      assert_equal expected_linux, shell_output("#{bin}/dua -A #{testpath}/*.txt")
    end
  end
end
