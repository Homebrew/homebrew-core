class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.17.4.tar.gz"
  sha256 "8fb62ecf5dbc3369cca56cebe9298c84791c688b05f98d155dc58ac208f541f2"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    manifest_sha256 "73fcccde0444b5df4a514fcc3cd4ecdfe618363f1db9b996f95ac890b307a811"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4352a460317174a1bd6e938863ac88bbba2263ada4492e5884f8cc61f486403c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29479cf2c9877d151a3c3005bc7441a786a0b33c7f0ebb48a9d1668fb972b1a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3f9ba92b95052fc644ba6b878a2bac7776bcac837432b19edba7cee19e766d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ce5d3bd715471ea78b04462d46f792ea478a74e7d965410b00c39deaceae1f9"
    sha256 cellar: :any,                 x86_64_linux:      "c0ebd519549c878449ec70ee8c1c003be8fcc16662326c70da6c31071f46d7ce"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"assh", shell_parameter_format: :cobra)
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
