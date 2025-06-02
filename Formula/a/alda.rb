class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.2.tar.gz"
  sha256 "1dc4ad595a14a6c5a2f93dc30f2c340f68a9353bf2f8eaa5ec285b622a33260d"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ad08ff6305f79d36937d90a192a61f9843ee941b94b81983036ea885185cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b43e3fcf177044bbf79bf1232e6e6b68515576ee984c4b387225f48ec92c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5243492f9b3514302f73a0280191529a5c95b2c3b66b7da2ff032d2a23d9ce7"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed4c88c3860eaabe07b13438f8c94728900b3aaf7eb05707b03abc5ef6edc56"
    sha256 cellar: :any_skip_relocation, ventura:       "2a8f6d59392a7cb4fe7909d70409937090e58071bc6e84273db45a6e082fe658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea20a8d43ff853c8851db04a6f0c5a083210ef57e2bf792e9c646665f14bc7ee"
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
