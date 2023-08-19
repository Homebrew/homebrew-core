class Curseofwar < Formula
  desc "Fast-paced action strategy game"
  homepage "https://a-nikolaev.github.io/curseofwar/"
  url "https://github.com/a-nikolaev/curseofwar/archive/v1.3.0.tar.gz"
  sha256 "2a90204d95a9f29a0e5923f43e65188209dc8be9d9eb93576404e3f79b8a652b"
  license "GPL-3.0"
  head "https://github.com/a-nikolaev/curseofwar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b2f8bf83947f4824e28c212a1fd901c499aab1c20b7c7310cebd07b0da6600f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ddaaccdd08f5cb640149db8d7c78b01dcab50eff1c610b4e6f674b790d3629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc08cc6d912fdb3df613a397b1ac467e910a280fc2a4955971d53bb7555045b"
    sha256 cellar: :any_skip_relocation, ventura:        "a188c211e65d756a13002d91f5e2b8dfd72fc0043a449f2e0661eeb85ab63449"
    sha256 cellar: :any_skip_relocation, monterey:       "896a5aef76086dee7da0fd8cc17ef67635592b9cc38a68945a53e0224a1bdad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee70d95dcc146e21ceb5921f9fc6d5c77874af2571b69d0850eec729dc1cc0a4"
    sha256 cellar: :any_skip_relocation, catalina:       "ddd5726a8951c2ec18c9f26bbed80d2d22baeef02eb6e1f313d4591f0db7064b"
    sha256 cellar: :any_skip_relocation, mojave:         "5847323530aec077f4a17d4c4eb78ee0f90499940dbce3608aba6d4f39e3719e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b2a0646e145b7ef8f502b6f544d106c05c90974c0f8972285a5dfa753305eece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3b72a5583689d3c22ed79c41229339e374695ea4975f38ba74cc72ea37cfe7"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "VERSION=#{version}"
    bin.install "curseofwar"
    man6.install "curseofwar.6"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/curseofwar -v", 1).chomp
  end
end
