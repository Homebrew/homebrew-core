class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.1.tar.gz"
  sha256 "ec407e58ae0dd537021cf98bd65411114c58e7a3639201442d0a94d98cbcb43c"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d16e896c820bdff6de0747c19d7a1a59c98f2c73f60d0017609603a6e963eb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd1d2e2c39c83ebffa15f8bb5d2e7b9865f409bd7946b40e9cce30767f3f7033"
    sha256 cellar: :any_skip_relocation, monterey:       "1974f5d77f016c4a7c952d05fdc3fcd2aa847e8b031cb3eb0390ac01ae625914"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6d6b881fd78c2fcd33b2ce555be3de598e03c5a4498d7915971c71251a0f3da"
    sha256 cellar: :any_skip_relocation, catalina:       "57394d6f22b493324ed638bb4183245a0f5473ae7b8f122d1dc1a822f93b762b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206a7d349863cb665b55e0042db6cb702c8c3cd8529d5f56f332ad7c851d5bb5"
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
