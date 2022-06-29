class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.6/pgloader-bundle-3.6.6.tgz"
  sha256 "1837565d8fcedb132c68885a40893ec3c590b7da9ebcef1c0e580b19f353544d"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61c2dc4131e24bd3cdaf90e94b9e08fb240ab77991c6fb0e801edb1ebc6f3a25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fb071207e38986b0613ab151885aa13d882a9f19622da32ac1a7ef80530154f"
    sha256 cellar: :any_skip_relocation, monterey:       "568f7ee87f7d2653c07a80caf79ca38f8efdf3b242bde198f4c46990c7234f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e40f6baeee01f0629ad7708a179c04e316ed539583dfcec12ea00aba8702e80"
    sha256 cellar: :any_skip_relocation, catalina:       "ddd0386c2a2af5f6abd0a346ef4ca324b80732d13c4f38bc31f81d8d46180353"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
