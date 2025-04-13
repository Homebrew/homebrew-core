class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.20.11.tgz"
  sha256 "d540d7528bf60e2021137eeb0ea3182b097b76c9ca3dd8e80168926f6e9da70d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "d9c05950fee5fa8000d1f010b6eaad577ac5aa5f419c10f0ca813bd2c311a6aa"
    sha256                               arm64_sonoma:  "fbb32788c4d64e507bf8a90bf7b902c3a093661fc3e3aff08b4c29a7c96dd564"
    sha256                               arm64_ventura: "a886206a94a0b6048f75134526ce52e7c14e02d31b7e1c1d1a9c02b8b60a316b"
    sha256                               sonoma:        "185177f5904e445b7294fd3301ef9c10abfb1d55641db567c485e75b94acbf8d"
    sha256                               ventura:       "fc4eb723bdd5415ad33ea1d1cec829346aadba4632fd227f92f4f74fc6d5f0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924796822602c0d54f866e3ef7e7ac625e1b8032d4a1db054093a7b8e87e169d"
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
