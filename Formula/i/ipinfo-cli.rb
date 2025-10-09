class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.1.tar.gz"
  sha256 "b3acdfdfdebe64b34c7a1aa80de25fd7178a51105e588ad0d205870ca9d15cfb"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d4003a3599efd8fae79245cf56c6fc287316e88304e8b01f796c387d4575cef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0d429542dab200b1fe6efea35c8c1c6af0f619c8b3fb54ebb01953334d6daf68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24a4a6cf506fe7c3f61570df82ab98529c08de85cf884fc87251268670e2b322"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a23d240ffde98765e7fe943aa1634f194df0d23cd9160060b892b6554316d911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a612af30b534c65fa532a52be61ef3b74ced4a579439f90c1cff1200b5c9f346"
    sha256 cellar: :any_skip_relocation, sonoma:         "93d7de1ed1ffcb8e5e7399debf034c5818874fd09666341ed70d46031d0ebccd"
    sha256 cellar: :any_skip_relocation, ventura:        "1b62948b8934538adb736f4c828fe28ea5c12598adfa4023af12902d7021db24"
    sha256 cellar: :any_skip_relocation, monterey:       "77e2425a41302f25261670c67c2d84730e24ec207d2ae7eea3fb22c57e1c4f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "df0244e963291a67068c47f729a080c427294d54bcac835814ba450da51b1684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2880d661339a626ecb23cc58f0049c21f35c1991c1db50b9d40872cb5bac5207"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
    generate_completions_from_executable(bin/"ipinfo", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
