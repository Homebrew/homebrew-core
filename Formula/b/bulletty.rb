class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e13b5743ee66a1d62c87f1ffa791a0c290d031fbb5d9363ce2c1e81cda25682d"
  license "MIT"
  revision 1
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "276b54467e7d18853b850a2733618b8acf034d96cb0c8620fb910493525709e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dcf348a3261d945c78236f8176ae0c0f93426f31677f35aac636c63b9fda04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99fa74fcc376e511cb1bf4fccd3900ba3d0775d0ba9f63013e86743aa8d5def8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb475fa2896f91097b4a57dcbb847bcced2026a518bb15b9a66280870a36455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1185f9c0ed02e807928e330089cecf4c0426f4ebd591cd3e9e0d9cbcb015ddc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22544a74cc837d3877bfbc64e8b6fd66341b78b27c7966e71a577d80caa396c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Backport openssl 4 part 1
  patch do
    url "https://github.com/crocidb/bulletty/commit/732f1c7c253d1f0819e14f112c999b5d4160eca4.patch?full_index=1"
    sha256 "5d5d8f7c8428ad994854ea825ab7029fbe3359492f6f395cea547eb7a24eb0ec"
  end

  # Backport openssl 4 part 2
  patch do
    url "https://github.com/crocidb/bulletty/commit/a2bc60cb5d5c5301c818935fa3d6ad36e5a78752.patch?full_index=1"
    sha256 "6b45b5cbd4f7c3410a5feab98f7b46c7923e4923b50876e56e2ba5841122f728"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
