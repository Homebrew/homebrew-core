class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.6.1.tgz"
  sha256 "c64a5d370cb8f19c76d6f77e6a813e10f79f28b706e97c7142c44be32cb05f2c"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "a5eb8431ec3577f5aff3ec7fc9db124a8eab338270a8c9ce7abba596436b494f"
    sha256 cellar: :any, arm64_golden_gate: "84490ec496ee0d20cca9763d6e29fe027585c9121107c3a98bc4f891bb26f978"
    sha256 cellar: :any, arm64_tahoe:       "84490ec496ee0d20cca9763d6e29fe027585c9121107c3a98bc4f891bb26f978"
    sha256 cellar: :any, arm64_sequoia:     "84490ec496ee0d20cca9763d6e29fe027585c9121107c3a98bc4f891bb26f978"
    sha256 cellar: :any, arm64_linux:       "1b0b965d60dba497f369e3b1287f6b70ad141ce5a054841504e026ad49d7442a"
    sha256 cellar: :any, x86_64_linux:      "eebd7bd29b5d4228964290c456c4ee9c1427093d7234044b371a7f3163b5da9b"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    unless Hardware::CPU.intel?
      rm_r "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
           "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("bare-{buffer,fs,os,path,url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove non-native libsqlite4java files
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end
