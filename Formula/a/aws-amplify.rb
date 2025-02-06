class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.14.2.tgz"
  sha256 "0d53b7c5bda9dc14de04bec0d70468c2228e318b90cc55e9cd067238e356f09e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e529a8e1751ab06009e0c6aedaaed06739d02c33b830d22368e5e7d7168c22fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e529a8e1751ab06009e0c6aedaaed06739d02c33b830d22368e5e7d7168c22fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e529a8e1751ab06009e0c6aedaaed06739d02c33b830d22368e5e7d7168c22fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "899ed7b871d7f092aa4a35d29fa948a670530dcf7ebe5851c9bccafd606e5def"
    sha256 cellar: :any_skip_relocation, ventura:       "899ed7b871d7f092aa4a35d29fa948a670530dcf7ebe5851c9bccafd606e5def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbca0bb629a18db874648b4977e21a5f0c7966846dcffbcc35059f3d344fdafc"
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
