class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.1.tar.gz"
  sha256 "8136f4fe1c74344ad8b27d23329e23620fdea76fe8892565ff308bda3ceac8cd"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09d4341cecac9531dd44b96b2f52a32775469737eb6df9ec7861db1f8253942d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8569e28905afb0cbce78c191bed4a4f82919a5a4c33dbf90d1d1501f9c039b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce57b03fecb0b4155c55b19281fabb971f3132b90e7a4bdb9323465d27b09a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e870439ad6cdb59433ea8b3983a38b56aae62c83c4897b9d00f32098eb09bf3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "449cecf972dca30dee2e236c608b70f32c99071d792597e703bf21247f580b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "60bd98f1ca49d93de8feb9a7034951e5c8351011fe2ff78d76fd33bb0eb20eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "77bff4c2e20242de41cdb57f9b794f013d2f3a797bd474f36a5da289dfefbc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "666e3c967b722e5433d5c9a24f0efa73289af18ea5700042f2e275b09eb8f741"
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
