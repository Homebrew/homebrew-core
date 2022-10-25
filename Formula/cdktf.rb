require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.13.3.tgz"
  sha256 "4d86b3ca68333fb5299cfdd75f63831fdc4521f2d24338cd23112355576a43dc"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a19078a26d1c3f506890e8fce89066c8fbe01d89897a00934fd3049ec20e0d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b856f04094643fbded47cee8e7816f707260475f0b6e21cebc20552aff5b2b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b856f04094643fbded47cee8e7816f707260475f0b6e21cebc20552aff5b2b3"
    sha256 cellar: :any_skip_relocation, monterey:       "44e4904c5e0f9a41f830c10ba1a8a5784b854f9233b5bb78d74aba70d52fa3bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "44e4904c5e0f9a41f830c10ba1a8a5784b854f9233b5bb78d74aba70d52fa3bf"
    sha256 cellar: :any_skip_relocation, catalina:       "44e4904c5e0f9a41f830c10ba1a8a5784b854f9233b5bb78d74aba70d52fa3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b856f04094643fbded47cee8e7816f707260475f0b6e21cebc20552aff5b2b3"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
