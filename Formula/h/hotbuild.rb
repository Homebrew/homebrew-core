class Hotbuild < Formula
  desc "Cross platform hot compilation tool for go"
  homepage "https://hotbuild.rustpub.com/"
  url "https://github.com/wandercn/hotbuild/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "7e8c5c52269344d12d4dc83ae4f472f8aec05faad76379c844dc21c2da44704c"
  license "MulanPSL-2.0"
  head "https://github.com/wandercn/hotbuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48765f4b63a2e545792a90d0ccb6e708f73cfbac955015b6f7306ba86f81446e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48765f4b63a2e545792a90d0ccb6e708f73cfbac955015b6f7306ba86f81446e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48765f4b63a2e545792a90d0ccb6e708f73cfbac955015b6f7306ba86f81446e"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ec072fe72761ade35c29f2ca68fb14d3d6c1f9b4b72da1fd3fc5bb56fe209b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d8216f9117ce91e1efa69dc1365c74a1d1c079d1259d1b8accd4042f29ae2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854bb58ffdd0700d658589a05dd6fd5a61540f6600eca7cbf21bf02c924331ea"
  end

  depends_on "go" => :build

  # Bump version
  # https://github.com/wandercn/hotbuild/pull/15
  patch do
    url "https://github.com/wandercn/hotbuild/commit/1b04ea4e9e1327ef4d462256072d72f4f37040cb.patch?full_index=1"
    sha256 "b0bbcdf106914307265b4ac81d73667a8b2d4c2fd688cc76dd1e303f690b4021"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = "buildcmd = \"go build -o tmp/tmp_bin\""
    system bin/"hotbuild", "initconf"
    assert_match output, (testpath/".hotbuild.toml").read

    assert_match version.to_s, shell_output("#{bin}/hotbuild version")
  end
end
