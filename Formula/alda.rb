class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.1.0.tar.gz"
  sha256 "fbf3a297eb79adf3301a5cf8e8aaa2cd8deaa841390ddc819491ecf67cc9062b"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29640c2964d772ca4f92c5cc752e9eae15789ea5119372b86a330a0dbdd7635b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab0b4de95c0520908d26bec78cb89d8a6dd2637888b419db43c48136b7807df0"
    sha256 cellar: :any_skip_relocation, monterey:       "29d5c697a43b4d000a73d8f0b516ea10cd36390e151c21ef864beb9c770ccf56"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd4715e2bfa8aff071c42c7a0d5cf2f630f3ba6f2d884fe90e5b6073b3cd47b"
    sha256 cellar: :any_skip_relocation, catalina:       "5b6fcbe7f1143719281c8f268a983eba00609cf93013fadd5f68f8775c0c4aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410600cd86dea4600dd3954e82838c748b47e883ca01099a1c9214085ea0ae12"
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
