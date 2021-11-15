class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.12.0.tar.gz"
  sha256 "f4b8ef42582f86f208fe6947e5ca123e9b86d47e58e0aaecf822bbe9e9e74a26"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b66c39894c86ce43aa3e3fd2415cbfd98e7443b94d99f5a2c4058cb50977a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e89654afd5dd87dc505b09dd36ee2d0dd142f6a7955dce79db9a4f96713c77"
    sha256 cellar: :any_skip_relocation, monterey:       "482dce52a4f7a0dcc4a9b4664013d18373ea734f7dddd88b241dbec631e6d055"
    sha256 cellar: :any_skip_relocation, big_sur:        "b32614a996f726756faa62ca0b4e27ee7404e9f3341a8d8f1457d925e899bc65"
    sha256 cellar: :any_skip_relocation, catalina:       "77570e18528c106267cf4fe3f7a8160d7f788681885dfe16560280d9d450ad7a"
    sha256 cellar: :any_skip_relocation, mojave:         "46193d23bec30727a5a8b63d77e8f8a811dd4ffaf7b7023c832d7e3a24acc072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa11877000c3a322c5ae8a1402910e95a122554ae80321f8c3557fbc9063625"
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
