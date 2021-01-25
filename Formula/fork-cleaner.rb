class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.0.2.tar.gz"
  sha256 "1714d15318694c2b597ea6ebef9eaf3913a3f5b9b13bac0e51050ab1001cdd07"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7bdc9b4d3c9f20d9cf6d07a95ba95035550cc080662254c4018c417d05f2ac8" => :big_sur
    sha256 "9198de534dd396ea7efbdf034faf7a6f5b31f9c5d5d793456b4c4bcc46fa7a85" => :arm64_big_sur
    sha256 "170c8bac819883adab9e91fc90e39c4799fcab75dd654b31ef4069093596548a" => :catalina
    sha256 "6ece7b427bbb0c21dde939ed429e008361cd0308ec0c67f55659419413de6637" => :mojave
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
