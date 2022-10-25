class Hotbuild < Formula
  desc "Cross platfrom hot compilation tool for go"
  homepage "https://hotbuild.ffactory.org"
  url "https://github.com/wandercn/hotbuild/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "662fdc31ca85f5d00ba509edcb177b617d8d6d8894086197347cfdbd17dc7c2f"
  license "MulanPSL-2.0"
  head "https://github.com/wandercn/hotbuild.git", branch: "master"

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
