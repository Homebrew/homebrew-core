require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.11.1.tgz"
  sha256 "ed51276f1871d4973d42aabecaed5e31aba61c54d33c4d555cbc9f2726f63f96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "745b2ed8d75ad8f0bb2a3490013af2d54ac5129bdc61632dbd88f252dece6a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "745b2ed8d75ad8f0bb2a3490013af2d54ac5129bdc61632dbd88f252dece6a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745b2ed8d75ad8f0bb2a3490013af2d54ac5129bdc61632dbd88f252dece6a8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "79bbac66b8aaf5ae86c934a109d6f7edacbd1c4cadc173f67859432302561b31"
    sha256 cellar: :any_skip_relocation, ventura:        "c04fc1565d8f6b9789174a266d25411afd3c13cc4ae98c771dfeea66d9cab16a"
    sha256 cellar: :any_skip_relocation, monterey:       "79bbac66b8aaf5ae86c934a109d6f7edacbd1c4cadc173f67859432302561b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8447fbc0b727ad798d1fad8e9f7e1a19737dca3d8af19486e793a18dce194394"
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
