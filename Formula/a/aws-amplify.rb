require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.7.0.tgz"
  sha256 "b60a77ace3c7fdf022d94e27fa2be177ad6d320650a5bbf26d806269514b4d30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ca541307ca48157e74ad7a299534852b8c3ce4ff324456005d45b6977f4b53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59ca541307ca48157e74ad7a299534852b8c3ce4ff324456005d45b6977f4b53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ca541307ca48157e74ad7a299534852b8c3ce4ff324456005d45b6977f4b53"
    sha256 cellar: :any_skip_relocation, sonoma:         "92621155009c53b19652bafe07479a6c3fa754de6eec839baa4972093d4e0794"
    sha256 cellar: :any_skip_relocation, ventura:        "92621155009c53b19652bafe07479a6c3fa754de6eec839baa4972093d4e0794"
    sha256 cellar: :any_skip_relocation, monterey:       "92621155009c53b19652bafe07479a6c3fa754de6eec839baa4972093d4e0794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddafd6059fb3b1cfdae6020e4e1ef3a12da774bf9893bc78d1f36df6ca999bdc"
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
