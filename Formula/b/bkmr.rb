class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.4.3.tar.gz"
  sha256 "326fb7ef727f964cae15f4fd47daa4415d3fc5034acac7bbaa5960af4ca121c4"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b36025982ed266754e5bd59d0ed25e57e600cb5727e3fe39411d32914db513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2c1372edd1f40b5bf5d800ae313ab4c87f66c1298951446dd625b7dae5ffa80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1019fc0d68205d3dc54c2ac5556c5bde55058301a0e444c19888d150a19b822"
    sha256 cellar: :any_skip_relocation, sonoma:        "d800a6f00267edcbe97c258ae4c496812aad888f20d7b1a0c8e4fd9599029503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223cb099914d5af7c1398855da5600f3bf2fd15845500e152f6e2f39239112ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73be2e3a7e9cdaf868f4101102ef5fde52882c6c7c415cba19da30b07a4d9d86"
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

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
