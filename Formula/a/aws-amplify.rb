require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.6.0.tgz"
  sha256 "0ca64ac223ff8a0a7b31f1583fac555ebc3e32c9df9753bb0d2253c119bf424c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "930ec36915b9bd537365a98ac22ca2e1ff4e1e336bba7a79c5a958760574b7b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "930ec36915b9bd537365a98ac22ca2e1ff4e1e336bba7a79c5a958760574b7b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930ec36915b9bd537365a98ac22ca2e1ff4e1e336bba7a79c5a958760574b7b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2203145c06ade7113d6faf8dbdc0e3771b87aab40de336964daf6db84d3058eb"
    sha256 cellar: :any_skip_relocation, ventura:        "2203145c06ade7113d6faf8dbdc0e3771b87aab40de336964daf6db84d3058eb"
    sha256 cellar: :any_skip_relocation, monterey:       "2203145c06ade7113d6faf8dbdc0e3771b87aab40de336964daf6db84d3058eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4406702f0ea5f0ef0b5b1a658345620ae5a7e0012cadc0e647bc5c61fbe896b4"
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
