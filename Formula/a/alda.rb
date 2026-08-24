class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.6.tar.gz"
  sha256 "d6dd3d4903652c1aece681ed8af2b97043a99b61add58178ca766a4d9b2df9da"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77cd00253d788ccde2f2df5bd8018f7409e2cd052dbbad3390df29b8c1982f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b248c09766ed42abe03e7dd37b3bd81868a035e89e5a1fb45bf7ae41afba27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a37d6858a3c64e8765f13ca389bd9b1c3b7a8d3c43afbe1002211070a806da"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c0db635ece1b84543d4fef5dc3440c5ead1da3bd206773108e44ae3e867098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afa97091466bc0eefafbc2e9eb0fc5f5c8f9a5da77d1a431e654f186a513e344"
    sha256 cellar: :any,                 x86_64_linux:  "6b7b3a9931d7fe484d0e95a906e32fded0a1941074b54973b07c7b4a7cce6225"
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
