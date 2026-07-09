class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.5.1.tgz"
  sha256 "8f5bcb9b609e7d97527dc5b49819677710f54b05eaaafa62323bc7d094170de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6967a50fc0cacd18f887d8b8d2404280eeb48c82bfb19a120fdbb7d0fdf0bab"
    sha256 cellar: :any, arm64_sequoia: "8a21d262463ddfbeb76e39a84a34d196867a94b7731a450d14c05e01af8ed83c"
    sha256 cellar: :any, arm64_sonoma:  "8a21d262463ddfbeb76e39a84a34d196867a94b7731a450d14c05e01af8ed83c"
    sha256 cellar: :any, sonoma:        "9d450340eb2ffbe8f04d25fee2b58ffff82de23f1e9ed64e71477d4a2cdd13e7"
    sha256 cellar: :any, arm64_linux:   "4a14458c4857ad03d948488b3fdfaad12a58198a3ca388c3c7643890428aea8c"
    sha256 cellar: :any, x86_64_linux:  "f4988ff45b85a930071f9fdb3805b75d4c56e3580f68315f208b275df9b76a7b"
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
