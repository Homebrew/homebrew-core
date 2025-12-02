class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.5.tar.gz"
  sha256 "0d7babe617ea7e8e20db9cb0e9c95d8631e9d67babdcce73e26ebc545716365e"
  license "EPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4912e2d3e2170139b141265108123e4e0720e14fddb874cda07d5dcc3266f579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ba7e1c062cdc18395cfbd06c390420d0848b79181f1ea03857fdbad1007fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7910f43e3fe793ba0b3852420996d0afda849985c01c573f849e78478caf9fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fdeb527ed70db77f08e34e9c9d740b9de63a30923c29f33b8ee4cba35d1fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0169935fd947185c65f8285ff870accb9143ab6eef2a9c2cfd80a3c82145ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a11630d37ed6d45b44d13a439ec58452c819994148c623d4c9049ab0e83993"
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

    generate_completions_from_executable(bin/"alda", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
