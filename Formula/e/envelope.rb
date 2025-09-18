class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.5.1.tar.gz"
  sha256 "e07fcc677e375311f3c9e7f0594020c2c8da64f8ea6c391c3ad00641543e5927"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76bf8b5b1187b8fdbc81c0b26b3607bf2e38f678f2eb9ba9d9eeb076fd24d44e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46bfe1fb3dd3f87b793d29c5b2321de5a3c2166d9990775c7c92428c05a92992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f9b081f4ab7c78c9141d9d779dfdcf5049f54689ae17d2cb775a919e79ff11d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e761284f6f67e2191150e13948e0fc6937b443ad2cb068667b652b449704824"
    sha256 cellar: :any_skip_relocation, sonoma:        "962de83a7b02a7b3788e2deedea65e57017e7e7c1111ab57a4cf0c6bde263953"
    sha256 cellar: :any_skip_relocation, ventura:       "7179a447ff32c1b183df3d8874965d4dbbff08c7b6d3276e6b35765c73352626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61a0efee93d2871b57e4fcdbd8ce0f9ea5f75536786e6bc974d3e1fa8fcba15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d65cd41287ab72e1ba6d4cda1d79d78c1916099ab31b908d165e89097e70d63"
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

    assert_match "error: envelope is not initialized in current directory",
      shell_output("#{bin}/envelope list --sort date 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list --sort date")
  end
end
