class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "600db24b942669b215dc08758590c01b5587728cce814eea2f519b6d3d19857c"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e021792cbfbd5388acd8a13a02cc9e49238e1899ef4a5547f10724a340c6521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e021792cbfbd5388acd8a13a02cc9e49238e1899ef4a5547f10724a340c6521"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e021792cbfbd5388acd8a13a02cc9e49238e1899ef4a5547f10724a340c6521"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ccf787672cc083601d91b193b4bcc4f96b572410bbd121ba0428dbd29fef23"
    sha256 cellar: :any_skip_relocation, ventura:       "78ccf787672cc083601d91b193b4bcc4f96b572410bbd121ba0428dbd29fef23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d75fd44efb739dbc8e25698934b337f4daebaebdc805ac0a33a63dc05e8838"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
