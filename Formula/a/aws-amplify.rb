require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.4.0.tgz"
  sha256 "a0d9016b2fcda8f911314310e8ca05ce1e2b699181afc05fcbae67f265866283"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c0fb9cb26db8d867406614a10e8d95e9af7f6c85be7116fad540cafdd1c389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08c0fb9cb26db8d867406614a10e8d95e9af7f6c85be7116fad540cafdd1c389"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08c0fb9cb26db8d867406614a10e8d95e9af7f6c85be7116fad540cafdd1c389"
    sha256 cellar: :any_skip_relocation, ventura:        "6d137a1236a705e24793e929744a4e4ec4060d657ef02a3fd1fff8da70e7476e"
    sha256 cellar: :any_skip_relocation, monterey:       "6d137a1236a705e24793e929744a4e4ec4060d657ef02a3fd1fff8da70e7476e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d137a1236a705e24793e929744a4e4ec4060d657ef02a3fd1fff8da70e7476e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3baed96d99cf449db41d3a09b086225e68b3d2b27086a739833420679a543fbb"
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
