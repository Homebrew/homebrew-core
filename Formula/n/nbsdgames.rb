class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v5.tar.gz"
  sha256 "ca81d8b854a7bf9685bbc58aabc1a24cd617cadb7e9ddac64a513d2c8ddb2e6c"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7e6bf700f1b8b33e34ae73df1f19cc45b7be8451723adbaddea87ff03607a1d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "94204000ca22ca12b9419ab644c95487348c2b8f6ab7ba6b75a35f262a45f853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "354dccba0566a0c557da42b0bbcb70c83c6cc27414ee50d208fa51e99a62718a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fea6eb184a26268e400bccb2f730badd3562d92444e639a1c4cda2d49dd222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9916d331aa232bf41939171c3591f22dd296ee973d90c703506eaca528409db1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c391d3da850a18fa442189d014181b3c0a28e3aa5286b5259ad9ca16aa6a5563"
    sha256 cellar: :any_skip_relocation, sonoma:         "499fd563e5c7029ce2f4888343c592013b0a0d0f7756ae27220e75b41bb9aa31"
    sha256 cellar: :any_skip_relocation, ventura:        "ce71ed79e381d78d6868ae0e5089030abadecc94757157a17b2de424fb1fa21e"
    sha256 cellar: :any_skip_relocation, monterey:       "31c7b5a1fa5cb7650d7de984547049f8429476ba23b1965db44497ac2eb7ac72"
    sha256 cellar: :any_skip_relocation, big_sur:        "040fd2883d5c1ddd45b3bd27ed4ec12de532a1330bcc3e2cfeffdbb705d990da"
    sha256 cellar: :any_skip_relocation, catalina:       "0c0672afd7f3de647311b6ae155c73aca2e1803f8cb22c4e6240aa77b116d4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "973ede434c4c08704345cc53e1a09e1bf9b6d98958e89caf9d56f613445e1520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b311d8c8354dc0688b51024c40b2d632ff7d22587c89deeed8d559af092cce4a"
  end

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games"

    mkdir man6
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku -s 1", 1).chomp
  end
end
