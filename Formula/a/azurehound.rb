class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d750284f75070218bcaceb604916f08f77b06191ce1372d7d3f54dc70e01df1c"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f913fbeb620704b1e0aca49ddf071ca08144c6640eeacc85244ff01173b1eee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f913fbeb620704b1e0aca49ddf071ca08144c6640eeacc85244ff01173b1eee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f913fbeb620704b1e0aca49ddf071ca08144c6640eeacc85244ff01173b1eee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c310b38cba3874756f18debb933e1bd1c8f8ca0453f065c43ff060f561b28e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8caf8d47d5180683ae166e3558d5220566438a526c1184e745edd689b842ab20"
    sha256 cellar: :any,                 x86_64_linux:  "b5f08e24900c2145335790da02ca79995a85fc709d0737029e97ec13726be254"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
