class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.12.0.tar.gz"
  sha256 "1f972f070fa068a8a18b62016c9cbd00df994006e069647038694fc6cde45545"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ff572bce4302be865315fb8f3600dea1491f10bb527c808d88d3b6eea0cd24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a5ec25ca1ad776f4336830f309f63665c590521248e5a5d3a61bf6583f65b1b"
    sha256 cellar: :any_skip_relocation, ventura:        "4de41cd99e149ac7d69ad2c2be30870204072993af1c78789fdc025f58b4e256"
    sha256 cellar: :any_skip_relocation, monterey:       "1df703a623dc8dbb3423a593a9050ece0e560400a1bf07779968779e055e0fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed03ac5e81ded1c0e18ad0475d03ca708ea159939789b59049d63507bbe1be6f"
    sha256 cellar: :any_skip_relocation, catalina:       "85d88fda55b31414f8e91de69916c7c1ed8c3d48da54b7abab6fd09cdb8f195a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4fbe6eb66d7e58700076ef0f4b3f775e441355ccdb7d65451d327536dc75e1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "xz"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
