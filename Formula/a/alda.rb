class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.6.tar.gz"
  sha256 "5bbf4bf73d2fa4678f765835f21cdbd5247a6867fe9f2b576fa0d05f251cd27b"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da03f03f3357d98355e7381c7bbe109aeb2e76d15ed92ccfcdee5bdf0daa894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b822ff2c1171c6dd51cce0bc99f98f3cb33a26791319c0c6d12c1cc9e0f95bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "891a59b1ea233ac8ed1ce6a4391461491b1c7757c53fdac4cbfcaf8b4f0a5aea"
    sha256 cellar: :any_skip_relocation, ventura:        "27f7accab845884ed9f89c093425f8431ad98e9bb08da9192a95d0b590bd43af"
    sha256 cellar: :any_skip_relocation, monterey:       "7bbee55d174ac3908c2ab67d2ea3b42f3d9444283ab482a66bb02407ab21ef3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa5ee3bb6dbc2db914411928a45504dbd36e9a1776edfd8cf75c21722698ee46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "323baaf388d78c38e39d90f640a5498db734878ceb9d3f340cd17b15e45bd54f"
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
