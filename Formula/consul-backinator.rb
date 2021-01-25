class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.6.tar.gz"
  sha256 "b668801ca648ecf888687d7aa69d84c3f2c862f31b92076c443fdea77c984c58"
  license "MPL-2.0"
  head "https://github.com/myENA/consul-backinator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0289e669896c287102e265b0d164021c0eed4d0906d972d4b85df9084dd01a3" => :big_sur
    sha256 "579fbf5bed18b1db8efc3d97621580316dc3d2d903fe085be3cd3dbd3ef72930" => :arm64_big_sur
    sha256 "b984053374292f96bb3b095aa9338f15aa9962be4473f8eaaf64a43598f39c5f" => :catalina
    sha256 "67549b4afb1e36aa92374850a5b5285d04a046e4f0120687613a58b63eab057d" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.appVersion=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/consul-backinator --version 2>&1").strip

    assert_match "[Error] Failed to backup key data:",
      shell_output("#{bin}/consul-backinator backup 2>&1", 1)
  end
end
