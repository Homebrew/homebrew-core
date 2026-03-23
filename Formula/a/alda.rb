class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.2.tar.gz"
  sha256 "08b38d262970649a2a39b9f3c9044cf6be0da1459829ec057be8abed641cd7a9"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b6b90a96d613fcacf7d527fbb1320348c6e18d46c8229e221f77cb4aecb0d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a5a37ab38ce4dfbde1dd4c3a38e949c8039296e6e20e5d7d418b2f5b902df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f35d3b973cf1cf6ca203a5e9d65e5f7644c203977681b6a3892909d0aa58cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ca9c1f936228079f8ca4a7dc88e52c855315670288577d888f932e343bfcfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "672cfb7c4cc1ef4595170c4c189b0aa47b694b48023475b9f47540babd7ba221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e899e73ccd41f9a13d109c4853b42628fcc98c21627828eac517b2939df9938"
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
