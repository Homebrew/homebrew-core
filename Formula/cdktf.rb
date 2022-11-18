require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.13.3.tgz"
  sha256 "4d86b3ca68333fb5299cfdd75f63831fdc4521f2d24338cd23112355576a43dc"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b6cd35e08b5a54eb703d83885851dbb4251cbe1c9699858da0a3992e56ba15f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b6cd35e08b5a54eb703d83885851dbb4251cbe1c9699858da0a3992e56ba15f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b6cd35e08b5a54eb703d83885851dbb4251cbe1c9699858da0a3992e56ba15f"
    sha256 cellar: :any_skip_relocation, ventura:        "cd4531f9e210b57808091b1c899f21b80091dcd379c59d008df641564530ed37"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c2c0e89a1dd036df84827c9a8171a1f9ab1e3ff168a9e7436f5afe98ff8652"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1c2c0e89a1dd036df84827c9a8171a1f9ab1e3ff168a9e7436f5afe98ff8652"
    sha256 cellar: :any_skip_relocation, catalina:       "d1c2c0e89a1dd036df84827c9a8171a1f9ab1e3ff168a9e7436f5afe98ff8652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6cd35e08b5a54eb703d83885851dbb4251cbe1c9699858da0a3992e56ba15f"
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
