class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6a1fcaef8ba7039f4d907083ea42c9b9a100ed2f4d0fb300a11c6f04e17540da"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4552aec89cd3e2c3fc0fe4cbb4c31ded26545c3b521b3b60eee8da5962f30473"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac6b6e2cfc915f331a50b3c1909c1a959b8465149d5d4c4bbed9e97cd41924c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2b0e0a522ac3e1aaa980728930b6ff82c862de59217bcc7bb235186912f2e30"
    sha256 cellar: :any_skip_relocation, sonoma:         "f986f9fedacd6bb4a725eba2f03b58faaa9dbc7ded922e1df7599455c8fe25ad"
    sha256 cellar: :any_skip_relocation, ventura:        "ad93bb47cdb48bd1d9e4c3fc97532f67466245ea53e9fa460567a517ec1cfbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "e7edbb8753bb9b087a3b7fcbd74c5b7f1be904c4e4adc0a154b28afdf66f3226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd785c8248f1ecb8d29aa6b6f30522392bf6e8f441d735811ba88738e252a0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
