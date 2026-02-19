class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.7.1.tar.gz"
  sha256 "acfe66da7cb2f346b77a5765f9654ab006202ca1b9a8ebff962b197b20991bde"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76a6b6c0ea646684b375b7798200bc90eacf4f6969330b029cc736f6c5eeddd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397564db114f78927734ed5c189e403273bf4e20355b05b240d9056489ebc786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88e468a799162b506357bc487300f8f87e68af18c40db1ed7fb98be40c0b002"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff370cd34b277ccecd78aca77658ebefee23ba07420f804bd4dc23fa695a5a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166d27bb96f2f000afe1370ba515376166ebaeb49e46ddf2d1c56ad6a9d55212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117b3382613bd3dc89aea606c566619890c9b0d3c2ca401d26c097c7d8eaff59"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/envelope.1.md", "-o", "envelope.1"
    man1.install "envelope.1"
  end

  test do
    assert_equal "envelope #{version}", shell_output("#{bin}/envelope --version").strip

    assert_match "error: envelope is not initialized",
      shell_output("#{bin}/envelope list --sort date 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list --sort date")
  end
end
