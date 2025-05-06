class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.20.5.tar.gz"
  sha256 "d6ccddc6313d32932e2c637d5f1497992eb6b98e61dd0cb8ffab34ebb0823057"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e62d6e36b5261cf512117a4dfb94e680da4d60679b4329a237269bf97d2304f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d543def1339c0c2bd1193cb11c07c12837c5bf11060f3489a8ff7e3c9d099275"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3aeb77bb465cfa8ec6bbe65e98ccffac72f64a8a769fa7a96b4d1ac89f94940"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb2dcda7b42fd5f719805226cb14dde750a34f69904758bc8924ef34c572b22"
    sha256 cellar: :any_skip_relocation, ventura:       "bb91ca73c3750d781000a6bce12b0ed5c75dad184e7a82dd4495c126c4c94efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5fac8d813caf6b1a947eada139a7d574077c68507c50b9225946dd83eae5dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98252b36ad407f02f75d57e3e1ddd22e40c50b01117d3fa7fa6cdca5e9b1dcf8"
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

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
