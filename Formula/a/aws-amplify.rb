require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.3.0.tgz"
  sha256 "a34abb00ef7ac59858bd54ebaf1b6fb36e929b32af597577e63127bbd8b5c934"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962fda13373cec0ebe5af57ec1bda176902313ba5435ff5b850d6ba84c4074d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962fda13373cec0ebe5af57ec1bda176902313ba5435ff5b850d6ba84c4074d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962fda13373cec0ebe5af57ec1bda176902313ba5435ff5b850d6ba84c4074d1"
    sha256 cellar: :any_skip_relocation, ventura:        "0f9989c2e421a262196e66938ef8711689b187490b74d9389ec00bc1f2ef307c"
    sha256 cellar: :any_skip_relocation, monterey:       "0f9989c2e421a262196e66938ef8711689b187490b74d9389ec00bc1f2ef307c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f9989c2e421a262196e66938ef8711689b187490b74d9389ec00bc1f2ef307c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4fd45c7fc2641e992087ef8a358b00ff215ae29aad0d4008d4354318bf8dc6f"
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
