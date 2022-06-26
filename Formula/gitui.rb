class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.20.1.tar.gz"
  sha256 "eccec120dfd4c5c33a74d331a53f3d0c6cb7200e26b0c4c7873278eb951bc379"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d68a6ab46e7610a1e05f2111edaa588d1fc9c9f3ed8b77a9586acd46eea6819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eb961ab0ad57527c95921f4835da9ff10f6924cd5c5e792f361b92446771d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "09aaa256f4779237ee2f3981a84c5060b816246545d0cb58c9f120d2e48cb11d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1652b8f6822c2bdbe5627025d18d85a307597d880182b0dd0251e0027ecac721"
    sha256 cellar: :any_skip_relocation, catalina:       "60156c4ac3ce0632dc713de11d9643f1312191e7a7600a68d01fb433968820e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a79b2a12fbff18d42be963c43936c1bdf4db7ff0a474259b499528e737cde2"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
