require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.10.2.tgz"
  sha256 "1b571b7de90a832cc0120a19028790e4b47b5ffc212ffb63e4f7fdced0223894"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "725645cd8036d557e48f78ecd094466681fa4cc1ea07a1b06f0e8bab2ea4be2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "725645cd8036d557e48f78ecd094466681fa4cc1ea07a1b06f0e8bab2ea4be2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "725645cd8036d557e48f78ecd094466681fa4cc1ea07a1b06f0e8bab2ea4be2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8deb8e6001d17be6702d8079a7d53d8d16fd80d7f16fa71a2c2275e2885eb012"
    sha256 cellar: :any_skip_relocation, ventura:        "8deb8e6001d17be6702d8079a7d53d8d16fd80d7f16fa71a2c2275e2885eb012"
    sha256 cellar: :any_skip_relocation, monterey:       "8deb8e6001d17be6702d8079a7d53d8d16fd80d7f16fa71a2c2275e2885eb012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3bb3f8405973917af129be31199ca2c5f8e4b9cb47e9c98a2312e18a487997"
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

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end
