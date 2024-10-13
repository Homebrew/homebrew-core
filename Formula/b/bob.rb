class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "cf3bf4ccd6133b43f67ffbdd18bd994749366f1d06d3a2c55be75dddc9b14872"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2cc6c4f4d8f6574e4468e2dd8836bb35d0a01cc8003522d60c643e24bf1eba01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfd25f4b9f225014b4e64fc10f2a4b17d4aabb36762696320162ace2127e7075"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52be99d73767678f9ae93ff628598ab212d32d7447f29c5a48e5e97d9b9ecd52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f563cc3f649360276af08dd48ebfd9202736354a2070cadb80355286ee747c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7dea8c6802d27cc5f00fb056cf91019b72433718cd58b3b9dbc1e69a13112d1"
    sha256 cellar: :any_skip_relocation, ventura:        "dea63cbed1fd56d9d4eb59faf7b56ec5f77276e5eeb42e1a9d970b1d7b0b7a45"
    sha256 cellar: :any_skip_relocation, monterey:       "56f100c6cdcaf69cfdd31471817fc3872fde77fef061d32b7bd2e525aaf25aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f817d4431010c514473475c5cc9ed38687b61857bc63143496976534b2425da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system bin/"bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system bin/"bob", "erase"
  end
end
