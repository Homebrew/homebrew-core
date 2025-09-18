class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.0.1.tgz"
  sha256 "26c9cd8f594f986bc4a0390cb09baba3c295218cde5c04b74a39dd7e1d9489b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b369eeff7c3e5985b017561975db523f370da4a4db00ee8415fba029448b777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b369eeff7c3e5985b017561975db523f370da4a4db00ee8415fba029448b777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b369eeff7c3e5985b017561975db523f370da4a4db00ee8415fba029448b777"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e7e1c97ee53856c2357547987bc555df5a074025f112b154df39efb013fa980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b369eeff7c3e5985b017561975db523f370da4a4db00ee8415fba029448b777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7e1c97ee53856c2357547987bc555df5a074025f112b154df39efb013fa980"
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
