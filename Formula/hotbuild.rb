class Hotbuild < Formula
  desc "Cross platfrom hot compilation tool for go"
  homepage "https://hotbuild.ffactory.org"
  url "https://github.com/wandercn/hotbuild/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "662fdc31ca85f5d00ba509edcb177b617d8d6d8894086197347cfdbd17dc7c2f"
  license "MulanPSL-2.0"
  head "https://github.com/wandercn/hotbuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fc5a6d582ee188052e3daa22aa3c6063fb09aaef924deac5cbfe5f697e02f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547bc3bac1e2621f3f6d1dbc83ed412897b2aa1def4a08a5fdbfd2a24e9cde2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0ad321f7a6ab55d11b47e83963984eb51576264653ce4613183a03730f9c7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e255bfa37fa3ee34f2c35c5c00ec41879a0c89d17f9073b0dbc215b4be3649"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c61c0aa4d1a3f4beda6764e28af6de0ff60e0fc1df445e52d941daa921a82b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c327c9eddb60305d8b6a5ba1a164ae1ae416f2f448048804f12a42dd07bc8dc"
    sha256 cellar: :any_skip_relocation, catalina:       "32cf72dbf642a44b7a6ad2182fb42946583004a9e87b8a3042f43f918d559c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2fa25a273f069d799eb0d30e31b73ca3a8e9fd319c76a6f0171a661fe68ad0"
  end

  depends_on "go" => :build

  def install
    # fixed in https://github.com/wandercn/hotbuild/commit/16d2d337fc20b245a96a4bd2cfe7c0ec8657470d
    # remove in next release
    inreplace "version/version.go", "v1.0.7", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = "buildcmd = \"go build -o tmp/tmp_bin\""
    system bin/"hotbuild", "initconf"
    assert_match output, (testpath/".hotbuild.toml").read

    assert_match version.to_s, shell_output("#{bin}/hotbuild version")
  end
end
