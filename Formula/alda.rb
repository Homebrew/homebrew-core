class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.5.tar.gz"
  sha256 "5895896dcaea7678ae6aeefae5c49c548ff7bd23d2337985e8c1bb7fe431898d"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd64830c09f6331ba5966453089cb6457e6c0252c795225abeab2cbb1dd452fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a37fe3fa3ca0feaa05c6c307b3a1d47ab979c5e9aafec7761c17f5e4c1e788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "839c3b4da1de7e5cda68fac9fa9be95537d4fd79a95948e6a4fc82a2c2dea87c"
    sha256 cellar: :any_skip_relocation, ventura:        "82c28299c4f7f39933fb1321567388b06536d9307d88d48115658f65c3342a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "361eb644d966975c4b606ec4bdd888129ca372f8a1bc7c9dd0d9e38a9e077b76"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2893f324f06573139706e301546428a8501929fa7e06dcf759562f6fe8e765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa74eb3a46ff1cb069ca70e99d8e5f2405dbb4733567983a5513c24da19876a6"
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
