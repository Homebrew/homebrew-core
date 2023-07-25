require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.2.1.tgz"
  sha256 "24898317160dc1cad6855b86944b43020d31e02a68ea9bb2598a2c0ddda0cd6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91480cc0288aa6047a5763d038f46ff9f5b9f42f39193ee1ead8f76cbad737df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91480cc0288aa6047a5763d038f46ff9f5b9f42f39193ee1ead8f76cbad737df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91480cc0288aa6047a5763d038f46ff9f5b9f42f39193ee1ead8f76cbad737df"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba48a53dbefaf1a17205dedc117527f47efc26334229d07e2d072a75482f14a"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba48a53dbefaf1a17205dedc117527f47efc26334229d07e2d072a75482f14a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ba48a53dbefaf1a17205dedc117527f47efc26334229d07e2d072a75482f14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f85c0d9c73de917b979571bbd5cd2409acb00bc96b215f642fcb53a37d9c9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    unless Hardware::CPU.intel?
      rm_rf "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
            "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    # Remove non-native libsqlite4java files
    os = OS.kernel_name.downcase
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end

    # Replace universal binaries with native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output(bin/"amplify version")
  end
end
