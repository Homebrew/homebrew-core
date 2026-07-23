class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "3e5ad3cb4b89cf77994578695bdc6acc135e98e7526b761001bcb42a5c6e3bba"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74217d4fba9b13d78c69bf2cceca49ffd137fdbc0299cbef0c53d3e737b95436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde13571c735f02c163446fedcb1a63fd2eb04a9e804d0f251c77698924a3901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773b31e4b77a70c93ae99fd52a2224458d189b55a5cf4732da5cbe9c94ede129"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffba3aaff1c0d7aa82aa026884db5a95ffe6f1ae404971fa4fe9440728ec20b3"
    sha256 cellar: :any,                 arm64_linux:   "12ddeba94a28b6f7a4f09db8886e870e8a1a9e8fe4b2b3b72efe41ccf859acae"
    sha256 cellar: :any,                 x86_64_linux:  "92ea109117eaa2030d383748553dc49a0dca74489cee9a89b91d664dd5e5d203"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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
