class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.12.tgz"
  sha256 "90bb30b7eae861d2a7ab21d1fe4ddbf71c8f74e7b2c31052c9b9265ff69d4c6e"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "c1f18f63b582964297038bb4b67726fdd4f3679da303fe3db743bc50f8415b31"
    sha256                               arm64_sonoma:  "e69789750019da67bc16c2e137228306528a18f2bf92499c027f40cc98749980"
    sha256                               arm64_ventura: "44219e68aa1993c579b5f973322703f64209ed42b9bb4bbce4ad49a5d82a7bbc"
    sha256                               sonoma:        "3219484a717ff464e6bce5bf60688d37dda8a1544f80235ec15e5325bf1c8f6e"
    sha256                               ventura:       "055c2f47d7e4ed2fb81f2c978a9281e49dbfb802b7aa23a0efdd4092028a7840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd71b277d96e93d200479006af9ee8987034fc8e3706a9f2e6cd88619ee6cac9"
  end

  depends_on "opentofu" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cdktf-cli/node_modules"
    node_pty_prebuilds = node_modules/"@cdktf/node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    touch "unwanted-file"
    output = shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
    assert_match "ERROR: Cannot initialize a project in a non-empty directory", output
  end
end
