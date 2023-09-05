class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.19.2.tar.gz"
  sha256 "3a5637bbd3ef3fc2f8164a1af90b8894f79c1b2adb89a874f1f3c5a56006e18b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0898c435c13589304eb210f15f6ab3ca649f2f6487a9380dcc0f61f7117d5179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448311b0df68d2960d91bae38fe6a70ae43bdaee5b5f282a18793c1eaa2915e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6197b3cb300eb4f0ee9f3c7d87cf89ea5f0812ab94297169980a2cc0a589c5d0"
    sha256 cellar: :any_skip_relocation, ventura:        "13d49ccb3ec793eb72148bf9b9ef165c65198cfe912f5bfade27657e19c30e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "4e53031630575ee7cd4b17d4f9916c055c6f006c7da8965e7c53e0ec324e6c4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c800568a011cd5eb5717df3640524b4248656adf4d9a7cc2575ce40ad744b940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8c8908f8402680262893d66c663a9c4d98b572e71f5df6a44fdec3ccd04be3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
