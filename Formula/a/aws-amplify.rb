class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.14.1.tgz"
  sha256 "df63d83a593eb955668d2e019828b02549916e862eab145fa59e0e9aeac557b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4949f7d3af0d80fb711d74642af27516cbd7faf78a420fbdc1639a65b61cf84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4949f7d3af0d80fb711d74642af27516cbd7faf78a420fbdc1639a65b61cf84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4949f7d3af0d80fb711d74642af27516cbd7faf78a420fbdc1639a65b61cf84"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a3901a6bc2eb414cde8721b973f05e0fc5c2927afafde0e9419d50e159c2a0"
    sha256 cellar: :any_skip_relocation, ventura:       "38a3901a6bc2eb414cde8721b973f05e0fc5c2927afafde0e9419d50e159c2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e0e00492060234a6a833a34939d7b213da3b5c1230ca8d557afb2255cf27bb"
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
