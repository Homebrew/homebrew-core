class Cf < Formula
  desc "Filter to replace numeric timestamps with a formatted date time"
  homepage "https://ee.lbl.gov/"
  url "https://ee.lbl.gov/downloads/cf/cf-1.2.8.tar.gz"
  sha256 "52ce4302f7f9dd67227e5a3d09fc289127bf0ad256d24d8e1698733ea2e1fd48"
  license "BSD-3-Clause"

  livecheck do
    url "https://ee.lbl.gov/downloads/cf/"
    regex(/href=.*?cf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f9a58bff4b385a95708503e3e0888e6a62230018f8d56396c46ffd8ecb8f5a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "64ecc0262ba8398d5321ccc5ce9b6d39d0776e9d4d3a79804e0ccbb02fe59139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe6582539aa71c5a8bece92c29a4802f15dd735d147c834ca0bbd8e7213a84d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b5a8edb4e24cdae78ee7b41c64f408d447e80ec4d58e0bebffd23e46e8b2e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "889ed10c47853e2fdcdeb6f6bc4fc677f524b26bec7f5e91b94e5f763cb4ac70"
    sha256 cellar: :any_skip_relocation, sonoma:         "8adfb68d96bb5baf3559102add0b8242e1c2d2eb4f4ec577624adf49b326b034"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc2e7870bf045b37011c48612b393f9416a3f4e9cb2a8e49b1908eef5bd6adf"
    sha256 cellar: :any_skip_relocation, monterey:       "43b2f71f97887ebeb6cff4a87be8599161afe5d081db33cf01b1a1bbace464c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "465bafd8f283eff64e7b301eb57b3ddf87d783be1bc965e7efcec56636a2b49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ac7581dae658e0e16a2413c5c9fda7725460394f707c3f78c65b99f9557692"
  end

  conflicts_with "cloudfoundry-cli", because: "both install `cf` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match "Jan 20 00:35:44", pipe_output("#{bin}/cf -u", "1074558944")
  end
end
