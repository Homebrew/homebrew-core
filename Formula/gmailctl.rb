class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.8.0.tar.gz"
  sha256 "13aa443b50910546c5dc8987f3f1ed7d1138571d1d0a0199e18e02122d404044"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4eed374a0bffac03a5a86eb7a1407207b1850d292cb58d61a71b62b7d1c9a44" => :big_sur
    sha256 "2ab1b9da6845f3496eef7d65ad63692ae757c4b84b0618b36645563225d4fcaa" => :arm64_big_sur
    sha256 "d3a358debf1f7335f2736a28437b8106f917a9449593a498ccf6ce2589d813aa" => :catalina
    sha256 "7695c67ce6a12008b8c04a84d4899cf17d7bc5d3ad32a9bca35c101c1ca65195" => :mojave
    sha256 "c2803a3f282d5b1b60b76552787d13ad54d0403537380daebdf09105793b87df" => :high_sierra
  end

  depends_on "go" => :build

  # patch go.sum
  # remove in next release
  patch do
    url "https://github.com/chenrui333/gmailctl/commit/63504e4.patch?full_index=1"
    sha256 "e93ebc411b590c4966c115dfbf567271a77c51a4e3ae5b93fd114cf18ef4ecdd"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
    pkgshare.install ["default-config.jsonnet", "gmailctl.libsonnet"]
  end

  test do
    cp pkgshare/"default-config.jsonnet", testpath
    cp pkgshare/"gmailctl.libsonnet", testpath

    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1"),
      "The credentials are not initialized"
  end
end
