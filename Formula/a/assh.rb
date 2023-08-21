class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.15.0.tar.gz"
  sha256 "ff80cb7dc818af1bd2d7a031058cb2d4074b0f4af6f7d3077619901689744387"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3845487397a59b96211e7075a79f592854736420a7000787150af72eb45702df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31affa151098673530f050292e4d04659c3786cf19412b8f652013480519a20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "678036dadc14bc728ef7b7d0d7feda46e175deaab47cc6f8ad80bda74ad49d62"
    sha256 cellar: :any_skip_relocation, ventura:        "d24096cdd506cdd193a7316c563ccd35ec275d18fc0ae85ca42ed36c66571b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "2490103a8c5ef28f6eaf5d7e4286244de7367171431e959424829eb612364bfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5f782b77042bbc321d0e619d03b890147aa1e699f3d000206a10f1a8889c04a"
    sha256 cellar: :any_skip_relocation, catalina:       "778b845f4546ccfe60933063e24b1c9179d1e836f26581217ae1b094233eb41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760e85e343ce75d153710cb34214ea46f3217e16fc048330d835920a0500bfaf"
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
