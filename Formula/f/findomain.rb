class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/9.0.4.tar.gz"
  sha256 "98c142e2e6ed67726bdea7a1726a54fb6773a8d1ccaa262e008804432af29190"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9799caf0cac3e7984fc8af25bf4e0294ccb4191cef85c94c14c16b70210abb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6d3c09f2e4ea8d9035512853daa278ef1233fb3fdd735c41579420e60d1e60f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c0056cf6bdfcc01ceb24ba8a99d4e7ae192a0bb57b4366d568f6374f6c26398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "069d0907873ab9492cf514ea7ed4b657057270996397c09feef6fabc11ffa4da"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddd807330c175ac1b6040315a9c0a14edca29de2a88043aa51d1ed8a020ef39e"
    sha256 cellar: :any_skip_relocation, ventura:        "d17e25ff822169a4592c5e3662b23c949d76c101809c5b39e25354a9bb924ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "18b73d207b2c502c71ae66d382c4ff63bdd337702ffb4d09b63fba640d627181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6c56c142e8b88f2141eb8082fa974ac8b642fcdee05fd6f65b39237ae22e9aa"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
