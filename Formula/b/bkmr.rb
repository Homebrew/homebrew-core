class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.2.6.tar.gz"
  sha256 "7cdb4fd78b4a75995f0009529110d58246b301f2da00a616ba976c27d46c5ac3"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d81612c3dddf1f7a3d5ae180b1aefb4e1b0ab60e6b8628f0ac79964e1991a23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de39d1c0f032541a97a7a1e3a00e7e99049ecf144993fab665bb0b51f1682d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541c3bfc949f6a2323d34f05d018b178e6d370b2f52efbb6a9c366f4cda538e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc42ee0cafed4940745c38b4c380296c0bf507154be48c342cc21610aeac13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a06a4bc37ea70ab47c9f93fb9fefba3e3a4eeb3631328a8d007629004bc987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9086484514a1a46028ce7a10aba54e572007119d02a0b8ea3d9284be74dcced"
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
