class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.11.0.tar.gz"
  sha256 "8819b847cabddbd1a36893dfeadbbf60346bed14d38e36726248817ff101489c"
  license "MIT"
  head "https://github.com/moul/assh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "663557ce571688779f330df54ad9ed4acf4c2fd7d1435654b47a1050148d1872"
    sha256 cellar: :any_skip_relocation, catalina: "6fab930fc47ffc55f95cf2647eb49f215c7c1e2b3e813f6db716f4eb4d00734c"
    sha256 cellar: :any_skip_relocation, mojave:   "4e3bec33736c4da424e6567088858f604f5274b90b0d8a5d075655e7028283cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
