class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.0.tar.gz"
  sha256 "315875daf0df5540e31463bf2fd71d16804258e8a11985cfb8c3216acfbe2087"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70b15d48d260c4c4151aeb4840072851e511f2bab647a96570d9125caa0334fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dddaef9df6b36d60d45bd4d603d325b9a7f582e2c3489ec058e95d130dd7107"
    sha256 cellar: :any_skip_relocation, monterey:       "f84c38a36bc1cf132eefe87e6bed462fb9b0824224a884ba95c7766e351a37d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "44212b83df5bce6c0fc29d191fe44e0cf1e1790a16d562244a35ef97128ff8b1"
    sha256 cellar: :any_skip_relocation, catalina:       "a918afa8c62ec4e5eaea469bc2ffc55d2a230ddd59ffb4f327ffb9a715de4504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff5d2e0065217591dd9d3e1ea585ec4aefa6ee61ee062be1f9927f05a1f5a24"
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
