class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.9.tar.gz"
  sha256 "4add89de7e432842e27976995002e4f39b75b0f34a3569044f223e3b38c6bbcd"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "822eae0cff9a5b8a680ecfee72cfbd2365aa4897b7d20208f2f2ecf319a98e29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e3239dadefe9abba2cc5dd2fe01e9372eea1323d8a323ca0000497d8cbe335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f4892dc69cbcce604423af7c8bafb835ef013228d9a5e97dbfe4d1e97f0266"
    sha256 cellar: :any_skip_relocation, ventura:        "b520cc3e1cfa0c74a0d2c56e3e9764a3e113cf394982dee958ce9f088d7180c4"
    sha256 cellar: :any_skip_relocation, monterey:       "a6fb1f3ebd7fd5a9166aab74b86d806de7c028656f992334180a307f0dc1940a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e4648622ee8094af3988a30ec7e2562caab7d38fd9d9b8a8b48c43f787cf4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a81dcc8f59833210b4b9a8a0031aedfc4c3ac3440fff31e026b30aadc03234"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
