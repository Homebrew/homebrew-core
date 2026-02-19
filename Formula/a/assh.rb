class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "7640558e6ce57a2c90b628cedd2f639647e4845538e3aa261870098dfdf95445"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "209c0e4a19e3ef7eb4c919e9890e7f097889ab2d89c5faf48bc683d1f0b009bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2f8e4aefe7abd4b59bf0fe304fc77aa62490f4c3c174e85ffe6ef717c5cb67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbf069e4fd1b164eaa887bdc7db4017829f597863bdbf100040e98eca3f24ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c484d49632adb9f2c48718fd318943f10f7dedd7c9604150e0301ab0a94c92c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7246bde1ffd82fa3db3a9e9a3c0c27b0444a1a018422525703714d74ee45c766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ef049ad31bd6391ac717ccf6dbc5017a955ea9afb433bd4751948299b83161"
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
