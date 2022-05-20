class Bartib < Formula
  desc "Simple timetracker for the command-line"
  homepage "https://github.com/nikolassv/bartib"
  url "https://github.com/nikolassv/bartib/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "51ee91f0ebcdba8a3e194d1f800aab942d99b1be1241d9d29f85615a89c87e6e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54cd7e5b2fcb138c8f230953ab9813a45d673e11e5631f7bad00d5d53a5ded6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6e73303bc55baf9558656ae379b51902d57d0a92433e42fe1a254513403a6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "0a62d68e76c7e2d19bb850f9b5927371af4198ff5fed3d74f1d35d182db0f622"
    sha256 cellar: :any_skip_relocation, big_sur:        "05da52b9351526c3eee0454fe11f54d5390224090cde5f3a587a602f9ea140e4"
    sha256 cellar: :any_skip_relocation, catalina:       "3fae02e9969429909e8b3def04ae111dcf5e44cb8f19d956fe2109e877b43daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6789b43f67dc1c737caef85083c81fcd79b4e983f30c6e81bbef3ca4fe04e3b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    bartib_file = testpath/"activities.bartib"
    touch bartib_file
    ENV["BARTIB_FILE"] = bartib_file

    system bin/"bartib", "start", "-d", "task BrewTest", "-p", "project"
    sleep 2
    system bin/"bartib", "stop"
    expected =<<~EOS.strip
      \e[1mproject.......... 0s\e[0m
          task BrewTest 0s

      \e[1mTotal............ 0s\e[0m
    EOS
    assert_equal expected, shell_output(bin/"bartib report").strip
  end
end
