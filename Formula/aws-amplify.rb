require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.1.0.tgz"
  sha256 "093692aff26e512b3210c54e35e925c0c8ac1adf73a0ccc4c8970010d24bc774"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea4c9207f68fea82877e57c47687997a5a075fcd8382ab065d94fbaaa42a1ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4c9207f68fea82877e57c47687997a5a075fcd8382ab065d94fbaaa42a1ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea4c9207f68fea82877e57c47687997a5a075fcd8382ab065d94fbaaa42a1ace"
    sha256 cellar: :any_skip_relocation, ventura:        "9836102706070618dbf6bf0f6317880b1444d92ba222709e72fe4df90ed9dd5d"
    sha256 cellar: :any_skip_relocation, monterey:       "9836102706070618dbf6bf0f6317880b1444d92ba222709e72fe4df90ed9dd5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9836102706070618dbf6bf0f6317880b1444d92ba222709e72fe4df90ed9dd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f39a3a52d272d7bf3601b6524603cd779caa1eb735b9e023f063377fd385e55"
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
