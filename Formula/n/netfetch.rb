class Netfetch < Formula
  desc "K8s tool to scan clusters for network policies and unprotected workloads"
  homepage "https://github.com/deggja/netfetch"
  url "https://github.com/deggja/netfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6029d93da6633a626d6920944825c76b5552e4ad5175101f661281e30b36b1cf"
  license "MIT"
  head "https://github.com/deggja/netfetch.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f348ae302224f4718f13a478c19f69d9ed76f4bafeeaaf1eb5225f120874c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f348ae302224f4718f13a478c19f69d9ed76f4bafeeaaf1eb5225f120874c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f348ae302224f4718f13a478c19f69d9ed76f4bafeeaaf1eb5225f120874c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed6e81af7eb73ac9f563dc29ec51012f8602fef87ff7d40329282000fae1ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "750307bf8f80020a6332c8dba8acaf373dd34b7cc28dc992724424610c862d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e1457e33294c578c004ca1d16dd8c8f7c5691c7742c7ef1623c2cb7cd05e7fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/deggja/netfetch/backend/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./backend"

    generate_completions_from_executable(bin/"netfetch", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netfetch version")

    assert_match ".kube/config: no such file or directory", shell_output("#{bin}/netfetch scan")
  end
end
