class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.14.0.tar.gz"
  sha256 "711721e2aece3b4d39c170924db8bf0f82c75690811d8b50f2310ccb2aa6b07f"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae72f2394286ebd7acc99f03390e267e567c4eecd73be163cc57447f924a7ada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ed1ec7a8d4ddc38ecba180ffbb77d7349fc37e2bc90659264ea181d947cbc5"
    sha256 cellar: :any_skip_relocation, monterey:       "96a80cc240745d2aad6f087bf5f55a5381c1a48a98711d88595208b93d034109"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd0fce00ffd889ca5f2c1c0b4fc2ad30b2229a16cb54de02ce78dcad72362369"
    sha256 cellar: :any_skip_relocation, catalina:       "a0c9b3be0647214d7fef1575ce4d0fde793c1bf93abf207f76d95bcad3c6c732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2dc97d26ecb39ccb98b6be12a46c0d61dd27b9e7ad9b68be3eb5abf9dbc581"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
