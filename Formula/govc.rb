class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.4.tar.gz"
  sha256 "e09c0596639c1213254c501478a566cbb9e7fe64d9162d0ae93c7504c1002bdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2d0a694f266f97cff0ae24065ecb9100ff73ff146caa20744b5a249ebf720c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c0a603a76fe7f96e6f648b945a210bf662386f50b92acb82a779b64fadc99f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a60db5946d5f9d37e4719d50c214448093df5bb43c659a740c233646490fdf37"
    sha256 cellar: :any_skip_relocation, big_sur:        "755a12ef29509eb88df6a8e3e96fcdc4e4892676dc7e4db7c13b88d9e713f1f3"
    sha256 cellar: :any_skip_relocation, catalina:       "3bae7a06acfd2478c4c75d5a7b1657cc7f599850fbbae7a191283b14731ac429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3603e731449dc655ea78332df532d512cc0807283f6b3c6476f8393dbd11ccc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
