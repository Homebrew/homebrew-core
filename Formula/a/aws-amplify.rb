class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.0.0.tgz"
  sha256 "73169aa41a3b43a7c291cd573a512221a222196e43464a43e19f2c6fd327e25d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d899ba91a0f6b99213827e6e317367693cae9d57b65db697ecf06b8b6619c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26d899ba91a0f6b99213827e6e317367693cae9d57b65db697ecf06b8b6619c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26d899ba91a0f6b99213827e6e317367693cae9d57b65db697ecf06b8b6619c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "064687b55885ff2fe6caa2efc25e127a09d4d36a9f9c98d411d9013b27cad73f"
    sha256 cellar: :any_skip_relocation, ventura:       "064687b55885ff2fe6caa2efc25e127a09d4d36a9f9c98d411d9013b27cad73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d899ba91a0f6b99213827e6e317367693cae9d57b65db697ecf06b8b6619c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16be6775ab478fbe3dc806f0fd3e62f2b7f82355974d267253814fdee03ed32"
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
