class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.2.3.tar.gz"
  sha256 "f7257fdddb7712db063ed48058989ade5858cfa0d0a0ef6154d0d711ba6228de"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf786ee585cf53177bfbc776c65ea267921be8fcbd86c08fc6c3255fec808d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b515ffb6080566f9917befccc055bb856883882af6d43bc9d161fc710875c9b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38cd0a8dc9125a1b061a13f1d3f857824b636a836e7c2d4cd787a523f4e770ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "369b42fdb09cb5c382ff72841c9b33f1f1c13faae11775495967a486036034ff"
    sha256 cellar: :any_skip_relocation, ventura:       "5b328a5e3232fc22fecd7a586985763364ffa0e42715de85c98a644d76eef26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1164fe7f5905451050797d7d22de5a73edc5277d4c52a08e093b6d39e19e104c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79e9b35782313dff98ee8ddf368199a6e68f29457a1c22620e4712db35f5ca7a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
