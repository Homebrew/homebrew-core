class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.9.1.tar.gz"
  sha256 "fed8876c574061c239a1d159d9c7197e8bda94f6610f6e29e682d8b6dde60852"
  head "https://github.com/moul/assh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "210b380b1af14b7f4ea11f3c0f9546d7def3694f2adc5fcdaee31ab13112a5e8" => :catalina
    sha256 "cfa4b2e02ad1806a693f8a2474db2d0ea14c9613f86d961f9c7de3574547af2a" => :mojave
    sha256 "2564d6cb2cc3d52adc1db3ea4f74c1c73bded0cecfdd1079ac0dd6b88ddbe1c1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"assh"
    prefix.install_metafiles
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
