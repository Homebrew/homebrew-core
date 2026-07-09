class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "91a4951baf951580ef8eeda6096521026193c177f2ed4082c08a9d74442fd7fa"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43fd59165cf9a27004a30db23a82d7286d76a682990ce8e6ed7d5acead05c392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555cd679751baf31a842e2e861963346a1ed000f40f6309725743151a3cbefe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "831eb3aec87ca87963cb635b44a11fa3dab01812a95e10dfd15bd800e63728b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb58aaf885bce3f95038d88d9c5fc46a80382e5d832f37cbb11654a345839c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "253979991c7ceda8f70377422d2ff31238fbb932018d73ad9e5bc0392c97a85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf4a47dc3bbda7c13b597afe0fec8f18f137d6130b7ff602fbf10c411453639"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_path_exists testpath/"opensca.log"
    assert_match version.to_s, shell_output("#{bin}/opensca-cli -version")
  end
end
