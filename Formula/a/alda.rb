class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.1.tar.gz"
  sha256 "0d55dc2cd3d9b7abb6a91ee117c0079e7a5d81fac5b8c8e30bb070f854696eaa"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75c0b47d258e6e7913f766db0c22819679c4b5fe565d8b2e75817071a954a4c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a57e98d6e29acb9ee3accc52a4a64fa54a3fb1e05de047568bda7bee60dd78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54045afb6fbb6e41b656361f5a8746f603d202f5b4a48914311af5f755d83219"
    sha256 cellar: :any_skip_relocation, sonoma:        "6282e20ee062a9a29f7171d78509ae39db4f2c6a9b795b9cfcd5e75513880f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43c9caa77b36a35e9a877d567e8b3137170bf1141aa959f174ff8d6ba20c5553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9971beaa735a115cda3d3b9ec2feff88025370c0712636d7ce0b7003e0e6a31"
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
