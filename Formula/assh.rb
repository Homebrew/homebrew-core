class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.15.0.tar.gz"
  sha256 "ff80cb7dc818af1bd2d7a031058cb2d4074b0f4af6f7d3077619901689744387"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6ad594cc3ca142f3b9e674d20296cc9c2b5a7b0ccffb4250b2ed95710f8783"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b502fd5dc796e9ff7e35cf4636c238d0ec21546094fe9bd3f467fa7189b630b"
    sha256 cellar: :any_skip_relocation, monterey:       "90972582d4d7c8c8b53c355e7cb67e04bbcfcc13443a166526713fe3cea64bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac57bd5f964f9f71d89e6117512956874a85ef842d6b5eeecd7eafb03d0ab8f"
    sha256 cellar: :any_skip_relocation, catalina:       "7b6450a9c4797ec5cbd38e21e875fac6e49dd961d7c44e42261c2e78a754957c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fb22b39dda8f9805dd6ea3f0f8e48d31b33b5e9183ad8f5702ec75c246d3f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"assh", "completion")
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
