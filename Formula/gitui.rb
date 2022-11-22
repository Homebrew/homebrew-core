class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.22.1.tar.gz"
  sha256 "285e86c136ee7f410fdd52c5284ccf0d19011cc5f7709e5e10bb02f439a218ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae1a3d064adf9db8961ec103cfbf654c3feb6a5581af77ba665baa281263b411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ac59879bfbf1c2423adb68f0801946f8d9f3c830fd8691a82d81368d7b1029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7abe27d949527707ef151ff86d228503330355023bde2a91394897ae24351d3"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe199807e3eedc42f3723d7f38fed672807bc1048a7b253536b7e6b9d685b13"
    sha256 cellar: :any_skip_relocation, monterey:       "0f3aa439e1211c2906c23e7c1ce3e0f8cad62af40dd2dcf2affe7c44bc9bba18"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd2e3d448f4df7ab00afe9e51f9e8790b91e76f378d664fb715b3b4f44dee94"
    sha256 cellar: :any_skip_relocation, catalina:       "c96baa42491d823c260487348bd568a3da964001d8ca5c7bcea076d07687d5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7389efe4590ae54de43c9a70d23696865ffc39d731cc17c6d9116fac6e605e"
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
