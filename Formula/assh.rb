class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.9.1.tar.gz"
  sha256 "fed8876c574061c239a1d159d9c7197e8bda94f6610f6e29e682d8b6dde60852"
  head "https://github.com/moul/assh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "152fbbe9914afa34c2261b207075ab6b369e449b861122968e642f3c245d3061" => :catalina
    sha256 "992f04a214504314d7693517a30044664a877e8ce1708c733048e68aeaf9efe4" => :mojave
    sha256 "0760e5a1c0f3316155569944d7e71dc61ff02a5e6ce321fdc77fbc5fd90730f1" => :high_sierra
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
