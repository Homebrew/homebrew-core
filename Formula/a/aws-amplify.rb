require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.10.2.tgz"
  sha256 "1b571b7de90a832cc0120a19028790e4b47b5ffc212ffb63e4f7fdced0223894"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3766624f82cda6571eae57807b01f623fff80203e7551a39c3caf9fa865fd511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3766624f82cda6571eae57807b01f623fff80203e7551a39c3caf9fa865fd511"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3766624f82cda6571eae57807b01f623fff80203e7551a39c3caf9fa865fd511"
    sha256 cellar: :any_skip_relocation, sonoma:         "00b542e7d6d410afd0460c3d6607c11bc04f79a188c873aaa066e03d7293ec81"
    sha256 cellar: :any_skip_relocation, ventura:        "00b542e7d6d410afd0460c3d6607c11bc04f79a188c873aaa066e03d7293ec81"
    sha256 cellar: :any_skip_relocation, monterey:       "00b542e7d6d410afd0460c3d6607c11bc04f79a188c873aaa066e03d7293ec81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7cacdef09f30c9403d625235a4544cef36bd20208f13ea4db7f87dd44fcb4b7"
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
