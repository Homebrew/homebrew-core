class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.5.0.tgz"
  sha256 "a701bad72b2991317fa094fcdfdf8b1bb5885ea089326d38c901efc9c4441f5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6306010324300d260a7e96094214b793f4287203c6e60f95020774faf913dcef"
    sha256 cellar: :any,                 arm64_sequoia: "e4368c0eb954c02fab060b2fb05fef98a35a21557c51688412472e286d686962"
    sha256 cellar: :any,                 arm64_sonoma:  "e4368c0eb954c02fab060b2fb05fef98a35a21557c51688412472e286d686962"
    sha256 cellar: :any,                 sonoma:        "8346c84c26cdf1ce652c1bf6e97fda05110c903453d9dcda35c6cb00d34ae91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919570a74cc2824c8ab3aabd90eb5e2c13405edb43ae26d4d785668144f8bb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5cd451b33efd5da644333c04d9b9f1c12f8fc146d95459e8cf1110091200d7"
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
