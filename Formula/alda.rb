class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.2.tar.gz"
  sha256 "1f8cece803d3ecf4636d18f56e747a1cbe30d59f8337763dd953158fe402f577"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "665fabe9c4477b28f9f5827c9e39d281d9292e4fe4f9101bca87d5027afebe31"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8b2c3d3183cd45fee48aed3685129b0040fc59ab827bfa99313becd23079211"
    sha256 cellar: :any_skip_relocation, catalina:      "551e411211cf0d745de515b2c98a9060d891bfb0aac540c87f2eb18715f0e5cf"
    sha256 cellar: :any_skip_relocation, mojave:        "8bb3ffcd2139b6192bb8659d3f28db0625ef97a7d0da320bae34f3d7098f92e5"
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
