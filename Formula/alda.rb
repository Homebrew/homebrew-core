class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.3.tar.gz"
  sha256 "79866bd526cbe288a6a7acde53e3094f34c4ccd6ce829434e259472c06f3f565"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ce999a621197d49931385f95bd77cc5b9dfa76e14ae59bd015d32aeaf4e0268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de70c27431632f46051049e2a0f37ebcddafb9d2dd9eab136e32460b624b3af"
    sha256 cellar: :any_skip_relocation, monterey:       "1f0f632b58b6c0355717c83d66db1cd7ef7717b7b1dc0911bf2f75bfa1e22010"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5c01815a590fe579b0607027409b3fc3edc5fbe94512c363ed28017226df757"
    sha256 cellar: :any_skip_relocation, catalina:       "76e5eb429ef6ffcb638cc706c3ccd77f342a54b4fb519757124b6bbfa770e128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a14ee4c650b49bc5a21dcff024b739431ac250b2e1c6c48c5bfbfe3e847a7a"
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
