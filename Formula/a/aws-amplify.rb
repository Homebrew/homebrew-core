require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.5.1.tgz"
  sha256 "46eacfafcdf3842f5519e7d1a17461193ae275926c7046ce50bf1a81ce5e0954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4fe41450feac944525ebfab41be7f606b1402a903c45a5841a535aff2b0adce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fe41450feac944525ebfab41be7f606b1402a903c45a5841a535aff2b0adce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4fe41450feac944525ebfab41be7f606b1402a903c45a5841a535aff2b0adce"
    sha256 cellar: :any_skip_relocation, ventura:        "701399a9eba7f249f1da440df1b42f463232fecbee64ab27d6509812fde6cb24"
    sha256 cellar: :any_skip_relocation, monterey:       "701399a9eba7f249f1da440df1b42f463232fecbee64ab27d6509812fde6cb24"
    sha256 cellar: :any_skip_relocation, big_sur:        "701399a9eba7f249f1da440df1b42f463232fecbee64ab27d6509812fde6cb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d311f48d84d1f73c4b8859e72476f700b275ac61eb29280764ffc376bb52486"
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
