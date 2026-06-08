class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.3.tar.gz"
  sha256 "c7ebdcb9fc73f9821184a7bf6603076988ea626b2eda8c9b0249f3b56ec4df79"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8010b072eed593ea0172cb15253ab0c6ff6e10fdeebab183216a9f85b24c77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d4d8a66e87a95377e47049e34e89001dbba577d230038cd6ad9500b09104e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074493f36ae6d55325e5a718d07eed139b9d9976ac3d0ac1527ee2f029bde2f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d594aa983a4bfb5fd5865dd01a8cf462d0c290151a6a267306eec0dba28a2362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f592ed449b6735146d27e1ca1b17c841e6d34e9181bc4b56d160e03cc7eef4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36dc48b43e0f8d3fe3f778de0dba9b9c8c5c40f771e2447af609e81b49cb3a28"
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
