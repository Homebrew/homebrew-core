class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.5.1.tar.gz"
  sha256 "8e8814266b3a38a9fe2141a58882a8216999a23029808c590c8107eb03c7211c"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca75605b11a0e28b84fa0ef8a1788628e9e73693ca5a9aedf0f72018d8a7dd66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad93ab13aaf7f53c98394c6734e5bddbcf6407e8d5887d038cbe8edf71db68d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7349e4d895939c4cd445d4874ce7722d0fac4ba39e017762b86af8a02685be17"
    sha256 cellar: :any_skip_relocation, ventura:        "22ce13be472c109b7cb15b60171e3ec03bda5875d07025830f71b9ce276532bc"
    sha256 cellar: :any_skip_relocation, monterey:       "018f4cdb000bb71af0b9b40a455813b291b2ae2aa03f48e712e2249e8590092c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e7b44f0569d1555a73dae025168e125387d5ce91f0b93452600a1362f1f222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece87fc128173f5052f89ec1e004ae7e77525dbb613b4d2ce77c8966f77d358e"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
