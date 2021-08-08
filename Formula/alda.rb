class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.3.tar.gz"
  sha256 "42084c487c9cbdb99432552a34e6750f40b8bcbe04f402ba61f7f30d29203c13"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8ab9a5e7529dbc9347798c81d2381ae98e8306747785a1b8df3878f56dfba99"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c3631104a5028ae030de802445d63260ad25e3d4f5feb34288c17d43371959e"
    sha256 cellar: :any_skip_relocation, catalina:      "86fd08213de8b025627969372c129777d43b7de2505f792bb22541dee4c3a84b"
    sha256 cellar: :any_skip_relocation, mojave:        "391b8188cc57612b2d6275e1e0a714f267cc84c3fd893309a8ba929f6d6b191b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d49ac4bd7377b609e562f443ab5ca2363cc25f760483150f698eac4e6e1359"
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
