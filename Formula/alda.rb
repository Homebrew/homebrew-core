class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.0.5.tar.gz"
  sha256 "e5cdf70181c998f0af1bbf4f8f3badcd5a3ef5613960aff284c6ea67898f5a94"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3be9c0cd4d0ed9f7f9e11bb5dd75a132e36ff13e142cd1f6144b1f9df330181"
    sha256 cellar: :any_skip_relocation, big_sur:       "18f6ef17516a41a96520b924f22a68406f3449918dc46b0a44669677f865eadc"
    sha256 cellar: :any_skip_relocation, catalina:      "9413578a79b0875126ecefcbe880bf50bd0b123c8b1d2e57c37b608899f4018e"
    sha256 cellar: :any_skip_relocation, mojave:        "fb466b6d7d29cbcfff33eda6aa5c536888352a20a097259fc66bc5765272b4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27390b8f58778226b7d435701c560f32a02f29b583d8166fca77ef80ede64954"
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
