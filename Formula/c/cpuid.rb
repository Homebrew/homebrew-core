class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "467c058227b86d527bff7e2e1504748f99ca27cb69f3908189ceb18b1df8428a"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8db225f084a6723c03356505200ac635cb94bb3ce0204900eb62137ce559eaaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b65f000226c41729001db3a206845dafeaf87d39f5ec12465ee02797718399f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b65f000226c41729001db3a206845dafeaf87d39f5ec12465ee02797718399f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b65f000226c41729001db3a206845dafeaf87d39f5ec12465ee02797718399f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb55a4d8942c9131a331f392d2b56e4e1515163850a5afcb8e1a17ec100aa61"
    sha256 cellar: :any_skip_relocation, ventura:       "3fb55a4d8942c9131a331f392d2b56e4e1515163850a5afcb8e1a17ec100aa61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555f1ed20e4de1ce5bdc1ea1d5ed9cf01c1bb64f968cf1c1125200d988869acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de235784ecef52744cafc99dd9b01aae03ff3763514153d8305ecd4d9b2b0c39"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
