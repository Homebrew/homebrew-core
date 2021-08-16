class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.4.tar.gz"
  sha256 "948c0a3b00467e74759230fa589c6e59adbbe5ce86faad5ba86dcf2dc6e5e959"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8534e117cd30a2e17ec3f205f0b3a3bc8f2d9a97cc47f225445943d86f83e7a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d20aa732aba4bba381a67b2be7d381f07925564072988ec7233b50d5cc8f8572"
    sha256 cellar: :any_skip_relocation, catalina:      "ceb559532cf0c0dca31d9f31885f4826c5979028e3f20b340aec247b1276b79d"
    sha256 cellar: :any_skip_relocation, mojave:        "3a20dbbe017aa41397a6c5ba0fbcdf3fe52b57df33ef0ff01bcbc55143e14098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244220c9a614a40f8e6bc1e3ad4012c181cdd80f71076744834f832c46ad9496"
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
