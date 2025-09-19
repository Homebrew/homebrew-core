class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.2.5.tar.gz"
  sha256 "cbf076fe31c70ccc279a1b2bf776fa44e331a0ca1fef348803649d6e278c64e6"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc4c0058f5e8591f81f543bc77039c29e7e45bd0b1416a381b900e8005a8bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1310df867318122de59841dbaecfc0ae58d5729950a3819b13723afbf5155ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06330a9711b3f1c44d0a47a88a802a2bc930f2fc8f6b5535022e1691059f3d0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "928507808c72815ead4599f91b4e335b492edacbe4768ac34f2fa531fd37779a"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b01058ef8127484f8e5b853b258fb7a6934998651a4519f5847a255dd1a7eb"
    sha256 cellar: :any_skip_relocation, ventura:       "ed11ada030e1f4c0c3cd6aa83c5c7c2020ba63215342636be73f1226eb978a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97b7577f6759736252d9beecff123593354aad939ed8b95cebd63013955093e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6ef19713975302c784a41a9fbbba163d890bd764f47d0b43b604c8987fdef2"
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
