class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.5.tar.gz"
  sha256 "1029809789ebe2b031cf5ea1926b27da35bf39a1181df24245d76e367237b568"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb7d43b1e1194afc2fc3d134f0ae76b787d425adbed370b3fcf9e4eb655a5e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7d43b1e1194afc2fc3d134f0ae76b787d425adbed370b3fcf9e4eb655a5e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7d43b1e1194afc2fc3d134f0ae76b787d425adbed370b3fcf9e4eb655a5e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba4b9e9c28dbcb516a8613233f798233b61d886291aa9d09fb226c3e1551a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5153dff889751ae697e44483fceffe73170ea585fae160e04e50cb3ac7fd790"
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
