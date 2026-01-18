class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "9635d4123d344779728299627be57ee7ca26aa3ca65ed2fd4510a4fdd508b3cf"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fb1cf4fcd56fd772fb822cb176403c7e5b53fe748f6856107a110183df594a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64d54282d0089e756577840cbc85421f70a62bc887fd0b40a9aa1f4ed1914b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc81b07e98d1af7414c9f5daf44843e24aae63697162026545877599f4488f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "107e7c6312a04e8533c56fb80ccc64d1513fbbbbafe2e9ccbdaaf7c497885b7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2632f0565d8627eb0c74a77e8222e92c755fc5eb0f915e80ec04a041b3ce2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490d984610d2d2a1dab4d0c219d5a90c9d880f29d675e5ed453ff0d32d3478ac"
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
