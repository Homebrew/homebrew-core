class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.10.tar.gz"
  sha256 "6064676aebe4848dff0aee73fe73efd0ecbf6f521faff94d266ce88283cf568b"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407aa5d6b2f38800ef7c9163a0b36458accb97585c79216200fbafd66a734c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407aa5d6b2f38800ef7c9163a0b36458accb97585c79216200fbafd66a734c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "407aa5d6b2f38800ef7c9163a0b36458accb97585c79216200fbafd66a734c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecfa112b44890d4e7f642b877c481cb42f97bbde314fc3f129a2c013dd897e60"
    sha256 cellar: :any_skip_relocation, ventura:       "ecfa112b44890d4e7f642b877c481cb42f97bbde314fc3f129a2c013dd897e60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f1cbad37f37822d1bb0ce32758b0ca0b6649fc89ba0328a658a446b2e8acba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce13ee61313acec4f188de11c6707403489972057906b950aaf19bf5af8c6f6"
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
