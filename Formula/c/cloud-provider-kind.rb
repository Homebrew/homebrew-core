class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "61f7efdd17f2b1100f153c162494eba240f4bace459ec3d76fc5348d829e5f78"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596d1ff6c56251c8fb41e89ad8220dd476808b04e7e87fc7c98eeb6f278a4757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83dda7961b6246015d269cb7f3090b8f9010648d78c3ecd1dd2ef570a349029"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38654267338cd317e2ac0d5eee6dafcbe16b5c6788f2a9293e3cbcdf26e8ae7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "00597c278dbbf8e47c1b9312126f579d101daef091ca7f07903c2ccc32fd5c86"
    sha256 cellar: :any_skip_relocation, ventura:       "5882ef85ba5cb771df59a6f2b18d3ecef31c1464cf76d46f8af03a231e31aaae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5600f3b4a6051d1db96676692611da07417b677a30b8b6b94606a2fa57680af7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 255)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "can not detect cluster provider", status_output
    end
  end
end
