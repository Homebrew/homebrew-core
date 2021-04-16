class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.1.2.tar.gz"
  sha256 "1ae2c12ae535669d0f65d297f5ff79d36d37dabf372feb6bda3f7856cf14ef97"
  license "MIT"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f012312be4f0c5ac8ff5cd67dc2c0c8b46b2a997e3b2d2aba61f5cd582332078"
    sha256 cellar: :any_skip_relocation, big_sur:       "b922c7f613914dc676bd45200c91bb5a2f35f191e6d6a058cc0e8f30eb9562f5"
    sha256 cellar: :any_skip_relocation, catalina:      "18f987b67a107a3bf300ecde0a8bfe9ae11876f150450697b43d13d76f8df840"
    sha256 cellar: :any_skip_relocation, mojave:        "ce617fdad4c3a2eda141623da2e9eff59435f4ffd1c6a192efb6a8b5d13faa44"
    sha256 cellar: :any_skip_relocation, high_sierra:   "468cfcc770bb7a88baf9961d665262be06de01bc85cfce19385e03d6e381521c"
    sha256 cellar: :any_skip_relocation, sierra:        "24e13e681254ae28aae5d51dffda26d70c0cbfbca7c52b61f16f7496822c7d1f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9461c5ce8f0b418d4ab1180c1fff22ef847b0d0af740489b3553d1715a8dc8c0"
    sha256 cellar: :any_skip_relocation, yosemite:      "62a8d29afff9e7e99c93917cfee92a68495443234346a72f16c8167d6310126a"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "author@example.com"
    system "git", "config", "user.name", "Au Thor"
    system "git", "add", "."
    system "git", "commit", "-m", "Initial commit"
    system "git", "vendor", "add", "git-vendor", "https://github.com/brettlangdon/git-vendor", "v1.1.0"
    assert_match "git-vendor@v1.1.0", shell_output("git vendor list")
  end
end
