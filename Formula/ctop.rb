class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.5",
      revision: "c971d26d42a7998b8883fee32d4b29d424992dec"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "26dba406df41efdf330ee0c35b4999523f69c16eff095ac3c3935c674ea8f851" => :big_sur
    sha256 "13465cbf308c91d06d932837e7a3681ff484248fcfe66710bdc730086a000523" => :arm64_big_sur
    sha256 "1a8acea8608a1451d2bb263eeb469c9213dd27002e2397a9694d4f8708fef933" => :catalina
    sha256 "fa29c78f4b919a60158697b51bd8d5e7c90120bf496411bdc0ddbf45c09bb1a5" => :mojave
    sha256 "f90e8d5b775f60a289995a7015976af28df4a54550e29a39a0cead75dd0c4743" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
