class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "765dda37ed4fffdbf00ef6055a1e12fd63a16707b1ab1a0bbdc5749c19343bfc"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "33e7a015806e78f4b1fb07ad98ea9714b4d520bbfa04257bb8087e8399609750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0edf8630d52570d7d10bd8be300bcf8eb10ff145a95cb59ca0c76bf85e04fc25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0edf8630d52570d7d10bd8be300bcf8eb10ff145a95cb59ca0c76bf85e04fc25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edf8630d52570d7d10bd8be300bcf8eb10ff145a95cb59ca0c76bf85e04fc25"
    sha256 cellar: :any_skip_relocation, sonoma:         "f547bb2fdfe3faa96f32a2cfd4a4f704b29bb103c1ea64b68f21e53f88969dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "f547bb2fdfe3faa96f32a2cfd4a4f704b29bb103c1ea64b68f21e53f88969dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "f547bb2fdfe3faa96f32a2cfd4a4f704b29bb103c1ea64b68f21e53f88969dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "605634d94146c53b3f225c54e0d18d492d61997a0938f2e5359b8c4a18663795"
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
