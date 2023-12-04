class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "65633f9a76e00a218abc9f71a487cc1bb93a8951885915bd05337ebbaec52884"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_predicate testpath/"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
