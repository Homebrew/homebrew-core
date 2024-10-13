class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.13.0.tgz"
  sha256 "ab866b12ca7c686feb551fe2f9abc56b889192dba1cb1d1e03d6f42af0410d70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8aa28ccf9df1ce7ac285e2d479cc7ac2387581c35895c35e6331fe15c24fa37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8aa28ccf9df1ce7ac285e2d479cc7ac2387581c35895c35e6331fe15c24fa37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8aa28ccf9df1ce7ac285e2d479cc7ac2387581c35895c35e6331fe15c24fa37"
    sha256 cellar: :any_skip_relocation, sonoma:        "279e981881421d053d92f81891d6fdbd4790a6f50f8de5c18313cffe21e52de1"
    sha256 cellar: :any_skip_relocation, ventura:       "279e981881421d053d92f81891d6fdbd4790a6f50f8de5c18313cffe21e52de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f74450b24f282297347a77e999bba503ad0d21c99601d6ea03cf598dec63881"
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
