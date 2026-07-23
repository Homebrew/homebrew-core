class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "80d33252b5c27e65c1a1539cfc3d49274c7b53372ca5005399c00b465422dd27"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90d63d7a873cf718e770fbef532468ec2edebc8a6bd5704cd7c4f8c9d7bf554f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "683e1c8048760076146ce095596469ae2514d0cd2d60f3c2c60418289c9b8612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8adb4a260bbf2e5b517166888b55222d7867fd7bc110fa350ac15e1852a76dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "beda22fe935a54c00605d0ad185f0f148ec5aad08c5612378fc9837fb3643096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533d73958dd2c5a622ebcf0eff45c1023f48932861fd55c04b95f562da91904a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4976e76276e8a26c1023f8d799ad4607bd3dc7c05d46b4a2eb96a04b14d95e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

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
