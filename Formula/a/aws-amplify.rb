class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.0.2.tgz"
  sha256 "58c9955e3ea191246c8d955e13e3e54e16d80f8dde17e656c4a8fe2a53b8fd8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e452fd8306ea2fee3b10db349325a832a057195f6acd0ee89675ce242703bdb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e452fd8306ea2fee3b10db349325a832a057195f6acd0ee89675ce242703bdb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e452fd8306ea2fee3b10db349325a832a057195f6acd0ee89675ce242703bdb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9a9572557e94274297d4e037fd43a0c532f04e043dfc415df6ed82ae0e0daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e452fd8306ea2fee3b10db349325a832a057195f6acd0ee89675ce242703bdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9a9572557e94274297d4e037fd43a0c532f04e043dfc415df6ed82ae0e0daf"
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
