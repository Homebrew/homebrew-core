class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.6.1/pup_2.6.1_source.tar.gz"
  sha256 "4ed81032e258254450f52433bcb10759cd23cddbd3865ce9fd529b1d707758c7"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0dabb4b0a10a9e076f6fa31b561358ab389d0c94a28502cda395a99fbe3408e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f2bcc1b5bd41227828fcda3a31667f42a32918296265488b5c57475035bf4a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76ccde7881eb4634744c7c8ac17bb1e060f44726cd84b0690161fcaa88921dc7"
    sha256 cellar: :any,                 arm64_linux:       "66743e53da69cb80b3ce35e9ba96415d243e1b306a889a093068b6a9d57b6686"
    sha256 cellar: :any,                 x86_64_linux:      "43cea493581909e764a9c1b3b6c367ce96fff07c97c238cd0f5a9f1d227ce265"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
