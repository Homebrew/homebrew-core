require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.0.3.tgz"
  sha256 "1f63a5561c2c1bc9c7e8cc5d3d61811752228dbfd69551807fbc120d5ce47bb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f202b80870aff7ebd63a4e1026baa61d70ea5e7aa86fc86afde11985ed446456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11918fe4390cc4e309ac3983e6e40e4e9a750aed1987a94fd25a797b94c0da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f202b80870aff7ebd63a4e1026baa61d70ea5e7aa86fc86afde11985ed446456"
    sha256 cellar: :any_skip_relocation, ventura:        "40a1c324c407acf16be85fd28b335222988dc66f5c228352911125fec6aa9292"
    sha256 cellar: :any_skip_relocation, monterey:       "11ffc9603df38eb875818f3828e032e520e183e5b983eb4786b76048080c0f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a1c324c407acf16be85fd28b335222988dc66f5c228352911125fec6aa9292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f82b35cf4efa62a8b023000a8c9bca1557bc941a4ab7fa4db14de127fc40b6"
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
