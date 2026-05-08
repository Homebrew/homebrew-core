class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.12.tar.gz"
  sha256 "4c3e2d7d77c291bc869f3c5f2db34aff3d29e1b3ddef86902ce3fd74608cf938"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "328b3bd91d91d768c26cb46c1c8c51567e6122a4319890c51edbdd71e6f9799e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b9c59d8518a2936418190a3b497bb87917016e44fe08307a34c3ad64459483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fcdfb48598432e272198d2bc50ce8c07f2888c9ca917477e0d3c5c6d383461c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12e8cfd86299f3a8ed21bfc12294762732b9bfde0c8ac3170166a8387fed288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90af1b33d64214c4f748f7a5ec90b339db1273cab8564d5e2c873dae2d61549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db765a24accfa496500ba4a478440e6bd9576ce469554d1c6dc30d9a5e23b50"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
