class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.6.0.tgz"
  sha256 "16e843f3b73ee7339321ccf0f57f9f9039619665c3cda900d483d45751f35a62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7141f7a1604d069e4b4d00cee99562f76d175c4bbe83ccb21210424be24302d1"
    sha256 cellar: :any, arm64_tahoe:       "7141f7a1604d069e4b4d00cee99562f76d175c4bbe83ccb21210424be24302d1"
    sha256 cellar: :any, arm64_sequoia:     "7141f7a1604d069e4b4d00cee99562f76d175c4bbe83ccb21210424be24302d1"
    sha256 cellar: :any, arm64_linux:       "9a1934e1380dc3558f9da69b110c8c5fed491d1408e97f525aa18b96c8b3dc1e"
    sha256 cellar: :any, x86_64_linux:      "9258d6fdc8a34c56fea6b90a99a633c8dd493f88e2dc750c2574b1529acc8017"
  end

  depends_on "node"

  allow_network_access! :build

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
    node_modules.glob("bare-{buffer,fs,os,path,url}/prebuilds/*")
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
