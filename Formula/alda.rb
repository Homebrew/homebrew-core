class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.6.tar.gz"
  sha256 "1c6252b108d00d1213fe198c4c441fcc71e40e33cf6f8b71f753cc93897182c4"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0fcac6fa1a7d9cef658be487619c728b2f3d986d9949b4499a21e46c5160c903"
    sha256 cellar: :any_skip_relocation, big_sur:       "efa338a3e209a3a93f89e30027b77f7f8003099ea191886039133bd917c15636"
    sha256 cellar: :any_skip_relocation, catalina:      "919c6ad0865fc0cd185912daa0e0937d9e24fed135b95af938d6374bfb5e4b2d"
    sha256 cellar: :any_skip_relocation, mojave:        "513015f78c85c68a73e05b41075f2ba76a760afa1613bf6aa79f11995535f5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909dc6675c88eccfc9fff5b7638254d41026c20ae95975dd53d766d7eff68eb2"
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
