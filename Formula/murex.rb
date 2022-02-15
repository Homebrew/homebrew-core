class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.5.2020.tar.gz"
  sha256 "d4cc4dd698b5b54972780dfd4d4e22c5fdccccc917ba58e8e202eb6e7ac926af"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3a38564917b1aa1b63cf01f147ca645059c0d7f61f575d0f3ff8ede603ee7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52bd622b5f826d8dc86291aa8ec76e322f13ddc10bc760e48328953cd28878ab"
    sha256 cellar: :any_skip_relocation, monterey:       "7dca18f4bec03998aaa33e5771da63e6df1d635f0f512dbc1b718b63679e97bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "563c72f46b1c7d0b8b20e05c578e936d5437636a0ea77bf72e44dfa64630cb19"
    sha256 cellar: :any_skip_relocation, catalina:       "6091a1c86fbeca54f335aeef58bc768aed40ab04775da9e980f9165937c4028e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d6846e85d6558e9feac5c2165ffc55e6d15ecc58f065d6342eb1433d0b4cce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
