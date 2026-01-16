class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "769deabe12733224eaebbfff3b5a9d69491b0158bdf58bbbbc7089326d33a9c8"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38db4194e6c73d61d01365e344422ad23e3ab1384d61bef30aaf75db5db3de73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5433945b3eb446dabe6a51967215e163fc075721d1fa308d08a851d1a1ef909a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5433945b3eb446dabe6a51967215e163fc075721d1fa308d08a851d1a1ef909a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5433945b3eb446dabe6a51967215e163fc075721d1fa308d08a851d1a1ef909a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c1fb8986bc47a941874b3e3c42c915bc59266952ed06f621d948c33141d89a"
    sha256 cellar: :any_skip_relocation, ventura:       "a1c1fb8986bc47a941874b3e3c42c915bc59266952ed06f621d948c33141d89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe16f70242ebb3d1a235d15aa2cdb4225352b5bedb28e82a06ff1b122fab3f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8df3f7ff08e285a8e1a05b6bcf7baf24978719522b67f3dfaf3b9d4cdc8847"
  end

  depends_on "go" => :build
  depends_on "pkgconf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output("#{bin}/pkg-config-wrapper 2>&1", 1)
  end
end
