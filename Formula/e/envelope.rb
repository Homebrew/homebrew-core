class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.3.12.tar.gz"
  sha256 "6deb645775426bd9f34b4ed581a3b26e490c3dbcec742114a7e2ddf144b8586f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0cf2f0fdc14d5952058149e3e46e2676217cd8afc292acdac7a12156db38db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dac95f255b257fa8122c5c479422b3c368d67948eeb91bb7e3144ac72e5eb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fb67ba1dd8b37503332ff4e3b3c126460945a94891e7014c473065a59ad4c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd582e7e0b208fb0985c3e8ec7ed2058d7437c02b48fc590e83d7f51e138ddae"
    sha256 cellar: :any_skip_relocation, ventura:       "0157f4505292701dc9b16fb42a7d46b28a82a8a7205ca3c6451a36efaf4b767c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284137aa430e081be9a59a0c1616fbae45147d86ca8cc5642418959cf5f25f5b"
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
      shell_output("#{bin}/envelope list 2>&1", 1)

    system bin/"envelope", "init"
    system bin/"envelope", "add", "dev", "var1", "test1"
    system bin/"envelope", "add", "dev", "var2", "test2"
    system bin/"envelope", "add", "prod", "var1", "test1"
    system bin/"envelope", "add", "prod", "var2", "test2"
    assert_match "dev\nprod", shell_output("#{bin}/envelope list")
  end
end
