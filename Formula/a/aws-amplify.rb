class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.3.0.tgz"
  sha256 "0faac850f382f03be4206fc4400bb872c4b4a11d1b3b367c5890c8a9330c8c3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3650225f3b138d6f107bd3e6e3a2006d1f08cc1fbe8e52f4d526f2563ba75977"
    sha256 cellar: :any,                 arm64_sequoia: "7910699097650f4e46e999bcd48782fcd9208d313a2f5b02be169bf34f8e5588"
    sha256 cellar: :any,                 arm64_sonoma:  "7910699097650f4e46e999bcd48782fcd9208d313a2f5b02be169bf34f8e5588"
    sha256 cellar: :any,                 sonoma:        "2d2e40643abffabac5675e365c9a54283566472f0a4ff752344aad9c8b139055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0d244175ce168f230bf42e688f0ad116c47d1b506759588f13f3aa6eddad38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5f68f143e3f8759752acd44028f818bee90113739f7b0901649e9d4f54f5983"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    unless Hardware::CPU.intel?
      rm_r "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
           "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove non-native libsqlite4java files
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end
