class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.1.2.tar.gz"
  sha256 "1ae2c12ae535669d0f65d297f5ff79d36d37dabf372feb6bda3f7856cf14ef97"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce617fdad4c3a2eda141623da2e9eff59435f4ffd1c6a192efb6a8b5d13faa44" => :mojave
    sha256 "468cfcc770bb7a88baf9961d665262be06de01bc85cfce19385e03d6e381521c" => :high_sierra
    sha256 "24e13e681254ae28aae5d51dffda26d70c0cbfbca7c52b61f16f7496822c7d1f" => :sierra
    sha256 "9461c5ce8f0b418d4ab1180c1fff22ef847b0d0af740489b3553d1715a8dc8c0" => :el_capitan
    sha256 "62a8d29afff9e7e99c93917cfee92a68495443234346a72f16c8167d6310126a" => :yosemite
    sha256 "962f05607dbd8ea0669f081039ce2fad01cddcdbfe53859b57c9ef69d89cde45" => :mavericks
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
