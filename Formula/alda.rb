class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.1.tar.gz"
  sha256 "ec407e58ae0dd537021cf98bd65411114c58e7a3639201442d0a94d98cbcb43c"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc965cb30f76b8b9bcb52b892f249c56ec9ee98c52bea0cb4cd5c756141c8980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "633f43033473a796a7a646de4a305b999a5ae6263aec74518d75b7fc2cd2ddc2"
    sha256 cellar: :any_skip_relocation, monterey:       "3da06bca3b2156ec0394de66eead46ab974e80696effbf9652b70da091969bf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1092136558dfba7b14d4f64af2b04dc92fc60e0bb0c81f473bab3e78e55e40a"
    sha256 cellar: :any_skip_relocation, catalina:       "16a67e492daa32508016f9d79a1d7eddefc9f368755ea04e17230d46eb670682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d1ac156688181d35fe34da184e0bdf5e1ffc54f765e3c315bb99d7d2912a3c"
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
