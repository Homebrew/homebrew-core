require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.2.tgz"
  sha256 "cf37245757fc26bba033673673b5f566fc562ea10f8c4f2ddd0c7921d81f5127"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d255822c5cd23fe06706546a997a3b4b678f35781080f94a2981b04f166e3716"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d255822c5cd23fe06706546a997a3b4b678f35781080f94a2981b04f166e3716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d255822c5cd23fe06706546a997a3b4b678f35781080f94a2981b04f166e3716"
    sha256 cellar: :any_skip_relocation, sonoma:         "04a7f795bd0fbec31b32b033dcc6e4ebb32410fb01b3dd0fec45c82612510563"
    sha256 cellar: :any_skip_relocation, ventura:        "04a7f795bd0fbec31b32b033dcc6e4ebb32410fb01b3dd0fec45c82612510563"
    sha256 cellar: :any_skip_relocation, monterey:       "04a7f795bd0fbec31b32b033dcc6e4ebb32410fb01b3dd0fec45c82612510563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d08dc441d1d7ecd9e88bb73b42afe55ef495e1dfeb8296714c376760065e69d1"
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
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end
