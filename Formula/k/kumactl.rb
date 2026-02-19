class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "20b063174ae69295d73a5a7d2c9c2fcdfacd55ae83e135f16bb6c3019f32dbea"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc9b730ed68588d3364fbbd1ca30fb9b639262d8d7d3e9cd905d5b8b9b7337e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f80564c58f47377aadda859ec1df5d9e9f67e409be828fb026f3c3650778a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca34122dde4225075c6716320842cb6cd5eca903442498ee22f19c0f28df75c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7a68b6a40f2b5207f4043d03b35ab6611829bb168ad6821ee5809a3a1952b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a25c89d8e79e7a7110efae6f076ddf8dd70cec055a0c3c60cb41b0786ae807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd57c5e3d174e6602fe6adae7c9c712511898a0ee0e4b24ff7a9593056801439"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
