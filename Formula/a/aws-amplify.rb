class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.6.tgz"
  sha256 "f6773f0f4ffe1c25a8c023a03d37921f907c401fd1e776a950c26b31b2acf98d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "841db0d134a9cbaaed707558d4dfe9dab8b38edb01b87f815f276e8b0016f5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "841db0d134a9cbaaed707558d4dfe9dab8b38edb01b87f815f276e8b0016f5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "841db0d134a9cbaaed707558d4dfe9dab8b38edb01b87f815f276e8b0016f5d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbf9f9280e9971482c6cdfdb9f8a1eb45b975e8583a76ee6a6420e7ad135a8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "bbf9f9280e9971482c6cdfdb9f8a1eb45b975e8583a76ee6a6420e7ad135a8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf9f9280e9971482c6cdfdb9f8a1eb45b975e8583a76ee6a6420e7ad135a8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02b0856bdbcc0dad7eb21e8e8c245a54ab11dff471cad117510f060ad47ae79"
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
