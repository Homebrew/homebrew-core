class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-13.0.1.tgz"
  sha256 "fe7b1b6a7aa426612031a8712a0ae70ab94b24f6072a8866e92c12fe2598cc68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "489dbddaaaa5293c2fc43c1e8f367aec51630d4979f8e9f1557a868a336398dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489dbddaaaa5293c2fc43c1e8f367aec51630d4979f8e9f1557a868a336398dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "489dbddaaaa5293c2fc43c1e8f367aec51630d4979f8e9f1557a868a336398dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1120ac36e1da8e1521001928f952de2da94dfbf66ea059df558f6be80df9556f"
    sha256 cellar: :any_skip_relocation, ventura:       "1120ac36e1da8e1521001928f952de2da94dfbf66ea059df558f6be80df9556f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489dbddaaaa5293c2fc43c1e8f367aec51630d4979f8e9f1557a868a336398dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ac446d69172e164ece46c26cdf0ea866e0d1c2e57991e4aee0e3157776e4de"
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
