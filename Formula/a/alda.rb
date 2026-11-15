class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.8.tar.gz"
  sha256 "ff99d01029f081cd8f180ddc4cad06732b4d32f6817f5f8ceb73c96b7741f01b"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "331918f7525e70a2c8070aa2570bb636a80e384a8142b28ee27f4f3597ed1c31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "698d91011f327dd3d2a3c871dc9f832326561a6fb5ed36702d975f601add097e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ec38bebe40697ba05c96bf07d0175d276b7db956e0c057cd8f4c260511a9885"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e167819ca7f94e914687c435b8da045be70090f09cb661b30cc4d25301021e2"
    sha256 cellar: :any,                 x86_64_linux:      "d5bd86d33d8149007fa9ba87772eae8a7cbd75d10b85e41334b93aa941001438"
  end

  depends_on "go" => :build
  # Issue ref: https://github.com/alda-lang/alda/issues/510
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  allow_network_access! :build

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
