class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "11dda9b5648c2f2cad55c3f7caa5cfc4885db147dbbb99e780f75863cb0bac1e"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85322f4caca9b110d9e2265b7922c6051c96438cfcc9eb3f1f13e58872954ce2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85322f4caca9b110d9e2265b7922c6051c96438cfcc9eb3f1f13e58872954ce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85322f4caca9b110d9e2265b7922c6051c96438cfcc9eb3f1f13e58872954ce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f07a7ceaafc5ba5c3bf8e4484d829f07b372f8fd272bdf3fcb489d75c86da3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dcb2ce4396a7dd2b765ed48a39ecb757d4380dbe34f90fcc2442d7dfabb0741c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "api/react-ui" do
      system "npm", "ci"
      system "npm", "run", "build"
    end

    ldflags = %W[-X github.com/mudler/edgevpn/internal.Version=#{version}]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
