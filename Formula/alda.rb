class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.4.tar.gz"
  sha256 "9dc2fb0886e97be1906e6d0a96671ef9d0f52b9f91817e4c64741cd18bf8e0d1"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be7f749d13dc8d775578b52ca4d13b06bd9cae16b947dcf2424cc8172c2b2c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85514be019f5897dceb40189f3c91e79520c49fcf0504d9051611d6f1091dde4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "366276ac1b97d1fbbed3ae072636035776905b454caeecc5ca90f118b5fbe3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ac43f1e4040e8f6a8063909c46dbbee35821ee7649170cc0a9a79c57df0a927b"
    sha256 cellar: :any_skip_relocation, monterey:       "d1844d8b733cdae6a2981e336b5c92db1ba78926220ed03e94a2953e44a7c0ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "67a0da8bd2aa9cc90efed984b66fe2c17e007c90a09ae80323b21783e9046a19"
    sha256 cellar: :any_skip_relocation, catalina:       "1af8e33fc2f0e120ccbfc98dd821507917ab66751243b9ef52b07e56f0cc194d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e247add4b87712ab8d2026dd549926105a59029a00ec46d750f194a620d15c"
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
