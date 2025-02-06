class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "0760248d2f440f24d9d219544c9c9e7d442a1b79568f7eb93cbb3680fc7abd89"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2432b67526b7f2d4247a08746eccae20e263a3683fa069ceb6d454bfd1e1b9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44879fcf0558b4beae80d665985a9df6fd435d0d159436177b74df3708ace87a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f52d556b1cdc398400e073a8a4966c90675c9ef6a4f3d482f41f38234f2aae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a944d1d7b18d0e03c8b52804e89400712860e2e359566adbf0bb16129937fdc0"
    sha256 cellar: :any_skip_relocation, ventura:       "00654659fbf7cc1fd510855cc77dd3bffac602eef4448079fa7e91ede7a2e040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9546712d2ee9fcda812023e2e0d98ae2aed1f47ce0f10b9f6754047555f17c8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_predicate testpath/"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
