require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.13.1.tgz"
  sha256 "089be9adc0930275e23d75ce5eee226b4e6c5647b136174f66419cfc03409721"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e095f267aaa76e784529791cd7fe6476a112ede27fb87582b36dcda985ab981c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e095f267aaa76e784529791cd7fe6476a112ede27fb87582b36dcda985ab981c"
    sha256 cellar: :any_skip_relocation, monterey:       "1661acafec11c13c4ff2385e4535d0091722644af59813f1d2728896c0ec790d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1661acafec11c13c4ff2385e4535d0091722644af59813f1d2728896c0ec790d"
    sha256 cellar: :any_skip_relocation, catalina:       "1661acafec11c13c4ff2385e4535d0091722644af59813f1d2728896c0ec790d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e095f267aaa76e784529791cd7fe6476a112ede27fb87582b36dcda985ab981c"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
