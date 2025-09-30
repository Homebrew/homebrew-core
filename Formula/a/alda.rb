class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.3.tar.gz"
  sha256 "eacb1f6fc649d0e3e159377c1084f1530469d2953b97ccb10720222aadcc8a04"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b3dced96ecc8d49bc3f70ea8e95a27a1872e379427a7e4bb25d97e6d87e8af5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4ca1302163e7a0a35afd5a98b86b8c4b0c9607df2e48c9dced2fccb399d682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3058e5e68f295158c638f9fca77218495d762fb9fae51a62303a416f3b12051e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9db76b22de729bfc98c8ccb60d91dec15f127bed3de0f6ba18cb6f46916a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5eaf0475905ef9d87f2ca57532377b23536b24f53746b92dca99a57a54075d7"
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
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
