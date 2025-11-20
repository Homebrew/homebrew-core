class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.2.tgz"
  sha256 "3966d8cb0259411a6cad7e9f7685c392595fd6309c21823a36694fc16d092fbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7246da131d5dca7f42e9fa9678562c96449a797679fe3c1f6a0ee42196f2c438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7246da131d5dca7f42e9fa9678562c96449a797679fe3c1f6a0ee42196f2c438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7246da131d5dca7f42e9fa9678562c96449a797679fe3c1f6a0ee42196f2c438"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fab1c162fe7a108f9e101feee84e1d8d4c1705b0c56558a9f8a14f4f28a75ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7246da131d5dca7f42e9fa9678562c96449a797679fe3c1f6a0ee42196f2c438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fab1c162fe7a108f9e101feee84e1d8d4c1705b0c56558a9f8a14f4f28a75ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    unless Hardware::CPU.intel?
      rm_r "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
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
