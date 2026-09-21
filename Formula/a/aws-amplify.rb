class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.5.1.tgz"
  sha256 "8f5bcb9b609e7d97527dc5b49819677710f54b05eaaafa62323bc7d094170de9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bc5bcecf4c47bcbe4a7cf2745a39c79c2c260aea2943688bf11f7fe2c2cee864"
    sha256 cellar: :any, arm64_tahoe:       "bc5bcecf4c47bcbe4a7cf2745a39c79c2c260aea2943688bf11f7fe2c2cee864"
    sha256 cellar: :any, arm64_sequoia:     "bc5bcecf4c47bcbe4a7cf2745a39c79c2c260aea2943688bf11f7fe2c2cee864"
    sha256 cellar: :any, arm64_linux:       "aada36c4fe0c42400e0b888b6c6a3c39b42877156320afed4a4c7499bc7c253e"
    sha256 cellar: :any, x86_64_linux:      "0d6bfcd36d2e6f0407530539fc76e127e223ffe9481a2cc88ee95613f69c5cab"
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
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
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
