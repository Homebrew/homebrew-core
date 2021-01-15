class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.0.2.tar.gz"
  sha256 "1714d15318694c2b597ea6ebef9eaf3913a3f5b9b13bac0e51050ab1001cdd07"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "21c159f9b3bcd5f5155ad18ebceae61437db7518d9c0731c84542ffd9d5dd1bf" => :big_sur
    sha256 "7547bd412bbc2cfd25670359effa43ba5d5926f3170e1884184a22113f4d917f" => :arm64_big_sur
    sha256 "a3a153a1405133680f0bfd6172032ac7a5a0daf9f3bdf60185692d6c76a44e72" => :catalina
    sha256 "cc23785568a1364c1e4b5128e784768a0ff1a161af402ab9bcc58f44e6988c94" => :mojave
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
