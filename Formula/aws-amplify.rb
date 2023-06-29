require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.1.1.tgz"
  sha256 "0a97fdf0b5e07e286de91c58d44d440a13a2e5a7002dd2260e0fae5f253e5f50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20cae503b91781e2cbfca4d015b807c94c8eac10f8d485467f88b4fc0fbfa0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baec3e173dedb202e83434e861466a1a58e77ce0c198048391b4b7ad31eba3ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20cae503b91781e2cbfca4d015b807c94c8eac10f8d485467f88b4fc0fbfa0c1"
    sha256 cellar: :any_skip_relocation, ventura:        "e7720abfed76b5d151ff74b4850a36141444150b410c132fe9547d8707a60fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "e7720abfed76b5d151ff74b4850a36141444150b410c132fe9547d8707a60fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7720abfed76b5d151ff74b4850a36141444150b410c132fe9547d8707a60fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecff16c98ce7e5f0317d135dbb5ba8ea3e2861e08a483613254261683a1e4bd2"
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
