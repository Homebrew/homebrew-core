class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "9635d4123d344779728299627be57ee7ca26aa3ca65ed2fd4510a4fdd508b3cf"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "11ccb1c7d31ec14e1328c0da793dd9140a26bbeb4c67f51c2722bf26c553c632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "075a77507a18b82139c596e10594bf5584e3ed53016bd3d1fa43dd2bbb85afc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d4c84e457f4a186f199a65311f8ddaaf8c05f60387eb71f16d7608d05afd75e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b8d0b50314b10b93181797d66523827c575c3bfdba89045969cc26badadaddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f821488002a3aec14d7de7ceb122e61b83ace0ff2f7de08aaa757c469a7c29"
    sha256 cellar: :any_skip_relocation, sonoma:         "58b30be37e3af425f3074bad8582766f14845de9d8c79454d6a41dec8d98ad10"
    sha256 cellar: :any_skip_relocation, ventura:        "469bfcb0438ab525e6522cd1041e3aec3aae29b7e8b7515ebc6557c034d6b31d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c5ef162523ae4a15d8cb5800666aad11a55bce998ac76805f0cf3a57455ef87"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b2dc1fd2114c9b5f32d977f9cda64204e183f585e04c12d94407baf9cde97851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "598e7c71ca8a20aec8985f1aee880fb6076081ed91622aa3983b41f3103f628f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"assh", "completion")
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~YAML
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    YAML

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
