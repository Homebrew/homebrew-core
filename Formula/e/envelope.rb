class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.3.11.tar.gz"
  sha256 "1a378564b07e041fbf3212655e8c6442f8973080cf0698886764ce38982661cc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3b39029d44b63c22689187ba607bfd908704b7a6f1079d8ce703b2e36babc380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b1c6693872f280e3835ec2d2d165f7a1573aad8062c6d532e54b64d172bb6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3722c57985931fefbab87d9626cc1fec6540648585b662a0d346401752902cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a28d3c6400f252fa81effabe3cf5c2b1deb17f8b165984cce4cd39e934f752f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3840579bcf9c3a0de3826f3a58ee7dbdf345fb4e88d124ee86826e99cbbd43de"
    sha256 cellar: :any_skip_relocation, ventura:        "0ac1e844f2cb4b61af8b3f14d38a8ca899827b4b5f6bace2cfd19f74ba393482"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e48ba6d4360ea32d899a859ed2056b539f04a6f11f7c128a573d4b023eaa36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0084ff7d440399bb969e0b3e05bcb197afa8357c36e7832baf44963804784a7"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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
