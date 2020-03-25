class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.8.0.tar.gz"
  sha256 "17656a6ac562707d6e85df44c1ccd04276fb1c08f1ff6a002291f4cb88880069"
  revision 1
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "152fbbe9914afa34c2261b207075ab6b369e449b861122968e642f3c245d3061" => :catalina
    sha256 "992f04a214504314d7693517a30044664a877e8ce1708c733048e68aeaf9efe4" => :mojave
    sha256 "0760e5a1c0f3316155569944d7e71dc61ff02a5e6ce321fdc77fbc5fd90730f1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config" do
      system "go", "build", "-o", bin/"assh"
      prefix.install_metafiles
    end
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
