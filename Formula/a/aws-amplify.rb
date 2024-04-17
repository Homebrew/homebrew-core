require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.11.0.tgz"
  sha256 "77da99b69c0245a7c42ddddb6bf0b25b95030e8d5a4bd3d972661ef464241cce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8929662b0e231a4fb0dfeaa097148232e9800eab679b49edfb2e5e76458269ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8929662b0e231a4fb0dfeaa097148232e9800eab679b49edfb2e5e76458269ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8929662b0e231a4fb0dfeaa097148232e9800eab679b49edfb2e5e76458269ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "aec7e7d6e2bf7367c656b309ac4c108ec337414df3a4ba4ccbe6c2ac020ab29e"
    sha256 cellar: :any_skip_relocation, ventura:        "aec7e7d6e2bf7367c656b309ac4c108ec337414df3a4ba4ccbe6c2ac020ab29e"
    sha256 cellar: :any_skip_relocation, monterey:       "aec7e7d6e2bf7367c656b309ac4c108ec337414df3a4ba4ccbe6c2ac020ab29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc19d4d368eef7e9cc9389fb1b8466b0e5f3da940e520a3865cbfc543b1776eb"
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
