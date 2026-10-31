class Envelope < Formula
  desc "Environment variables CLI tool"
  homepage "https://github.com/mattrighetti/envelope"
  url "https://github.com/mattrighetti/envelope/archive/refs/tags/0.8.1.tar.gz"
  sha256 "1c26bfa03ecc9326c3b3095e3b432adcc68dae5f0f7aa118e77211cba88949cd"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/mattrighetti/envelope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2007742a8dec2324db789f6be4aa2fce8a670a9a256a77f76a3544f1d924ced"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c78e1cb7b0f4243005ad306712befd7c831451cbd51d1c3d14dcfa24cbf3e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d863abc6c6052ce1796467ea4a0fb02d603906b3ce60a5242686f88f9dca280"
    sha256 cellar: :any,                 arm64_linux:       "cf26d5f471fc79bcbb4c655e2d57fe3f0ef1056c87eb2df1131f3b0e229efa65"
    sha256 cellar: :any,                 x86_64_linux:      "8d56e4ba67856801032584f246364840ef3ab75c5cd34142394055cf4dfae7c6"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
