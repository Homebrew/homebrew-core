class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.34.0.tar.gz"
  sha256 "6ee954538e0af38b53004ea8834e8fec6b36d22711b67132888d1cbdbb06a09d"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d3ae83e1a1f664c5ee162492ae01ecee19ea12110060eb869f1e2e75d4ff82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2397a629fb2fcecc656157462a1e6094d2b723f5045fd5d539cd037549b0c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8593e1a72d8c6e68a9862fed7e85dd0d19004abec196401e4cc4b48c2723b59f"
    sha256 cellar: :any_skip_relocation, ventura:        "84092e440209c0ec3312bcfa5d32ae3757bde98905a49ea3997d6aba5e536df8"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd7ce94f124a2e7cf2a74b7977da767d79d6207150abae8d15392824094d275"
    sha256 cellar: :any_skip_relocation, big_sur:        "850c4e2f5ac8521a17a53ddb9fed193c6c0ef46a65365cac589b98f5e5e91dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dfd58287bcaff326767b7f5423255ad28255c596b038ab2cf2341545b5088cd"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
