class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.7.7500.tar.gz"
  sha256 "9066ac189c989f6e65d2b040b1c43c996b77ef0cb98be73c991b674c0dea1add"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728d14717558ac822fa01a8632f5f75ad43a6d132c8d6f3f724968adf78687db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16a551592f2ddb54ce73f715ee75662ce8df7a8abed2983eb82db561597208d"
    sha256 cellar: :any_skip_relocation, monterey:       "97676b781e2060f5fa2e03a2f9300c581a33a1493156e124045cef94eec1e686"
    sha256 cellar: :any_skip_relocation, big_sur:        "c49c6019b163e8d395fa4fcf4912f571a62f5ae9042eaf6debf4d838da576424"
    sha256 cellar: :any_skip_relocation, catalina:       "7884fc38ac1e739445452f9c06d0dd96aad48d598be27d594fd387f88ac3a976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a06e7caffce4ae6c8563354722bf415411be9491cab7f91cfd77ae94a7704a7a"
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
