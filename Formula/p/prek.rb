class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "bac07fde865e78ec741bcf9aa4e6d63b03cafd0f706ff1d5913d7b6a2a2ff18e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ddfc13c19af043807b8147def040cc82c04f88b7e16ba73707be611fa138c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c683b24472e13230ed4d259541b57b6f5a73cafeed963e245fa0b6421f3b5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b3c2b488d22f85de9d4feb1eb995677addca76e73618d38d67b69c6bd7dc357"
    sha256 cellar: :any_skip_relocation, sonoma:        "569f1bc7a34a05129083a97ceb4120f89c84f9b00100659ec6e4f03654b1d1ce"
    sha256 cellar: :any_skip_relocation, ventura:       "affcb097e09e201c968954c006dbe772316295b77109bfe836ec892e260a5dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5c7e318a19cff7ca7d4907f6016a09ec8dc97aa634144988ec1844b468df74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eeba203b17b143ccce8775a46f7b2fdf9ea1d4624f775f7ee6dbbdc0ecc812b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
