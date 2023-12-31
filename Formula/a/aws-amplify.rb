require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.10.0.tgz"
  sha256 "a0ea10c62471468b51703ed2d904305754948fb96a1eed4e4f21d8f2bb889bb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20bee35fc0aded28cecc3045324b8e49dbdf727039a8be4a738c0710a4d05ca5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20bee35fc0aded28cecc3045324b8e49dbdf727039a8be4a738c0710a4d05ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20bee35fc0aded28cecc3045324b8e49dbdf727039a8be4a738c0710a4d05ca5"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c2caf13194d82c7cbf1e44466ccbf0492b024887b28aee91d0057c47f7111a"
    sha256 cellar: :any_skip_relocation, ventura:        "60c2caf13194d82c7cbf1e44466ccbf0492b024887b28aee91d0057c47f7111a"
    sha256 cellar: :any_skip_relocation, monterey:       "60c2caf13194d82c7cbf1e44466ccbf0492b024887b28aee91d0057c47f7111a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac940eb6a63e62f6a3874d4a7b05b25bc35390c68ce6d2f33eb6db6d69df325"
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
