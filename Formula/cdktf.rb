require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.13.1.tgz"
  sha256 "089be9adc0930275e23d75ce5eee226b4e6c5647b136174f66419cfc03409721"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01aeaa9c6e27ed8ea2487a40b8c9cf74fd4be0b0e53b70886d1527a973db775a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01aeaa9c6e27ed8ea2487a40b8c9cf74fd4be0b0e53b70886d1527a973db775a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8943c8b242849526f06ab25e93fee6b7af7e9227598e2f2f8bdc2d3270a573"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa8943c8b242849526f06ab25e93fee6b7af7e9227598e2f2f8bdc2d3270a573"
    sha256 cellar: :any_skip_relocation, catalina:       "fa8943c8b242849526f06ab25e93fee6b7af7e9227598e2f2f8bdc2d3270a573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aeaa9c6e27ed8ea2487a40b8c9cf74fd4be0b0e53b70886d1527a973db775a"
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
