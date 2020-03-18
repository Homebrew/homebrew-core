class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.6.1.tar.gz"
  sha256 "db5e41b6d5ecfd5a7dc14a2881d41521ce939cbd749e84882c2d7325c17fe886"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "23a1b55f97bbac97d9db5ae0f75cbcc7fc117fb54fc692e3123cfaccfee335d6" => :catalina
    sha256 "9d5c53422feafdd72a1aeabec54c4a0c7ed07a01b774d24b1feabe81041e511f" => :mojave
    sha256 "120ffcc07d412fc8d73b29b62400d315e8dea71401cc0b7b6dc227573ed4fc77" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
