class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.7.tar.gz"
  sha256 "69e94d2e0bf5df7761d17c0e9333985ed413beed339c133c6265bbdf4a5afaa8"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "753e71232f5b05bfee189f0d5b4b59a8b0ef1283f80f4465314c21c1a4514c11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ae0cfb1de4236c47b7048277ecc39fb24cf217baa26914196319688d75db907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "854aa92cd1cdbca315fdc14123e6faec34444bf33942d99951dfbc417dafb0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "eaf5dce3d4beec22fa0fe642a7209cd88b9c3596cc71acd2efd24c5d777421b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9983f3345b5d06c46e2fc0fdd02e10a298a63e7fdab3a8ff1b45d93f03f0eeb"
    sha256 cellar: :any,                 x86_64_linux:      "5d552db8448993f7773c733b3ae7c06e220d405ed713707e429dd19231c4cd5f"
  end

  depends_on "go" => :build
  # Issue ref: https://github.com/alda-lang/alda/issues/510
  depends_on "gradle@8" => :build
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

    generate_completions_from_executable(bin/"alda", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
