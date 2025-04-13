class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-13.0.0.tgz"
  sha256 "e6a51b857116bfe248acc2792177d64c1674e089e461e8f59a11f5de55d17ecf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b815adbcf5005fc8fdc9451f989aa5bb3878a72da7a10c4025e385151a2b689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b815adbcf5005fc8fdc9451f989aa5bb3878a72da7a10c4025e385151a2b689"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b815adbcf5005fc8fdc9451f989aa5bb3878a72da7a10c4025e385151a2b689"
    sha256 cellar: :any_skip_relocation, sonoma:        "616a497f1617a80fda7ffc8a390cacba1978550c13a3de8844f1bf3a700817a9"
    sha256 cellar: :any_skip_relocation, ventura:       "616a497f1617a80fda7ffc8a390cacba1978550c13a3de8844f1bf3a700817a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e54fb41e864697872c8b5ad8411d98a1a08f2530cdfad7e05498634da84a254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e966a4361bc51f0103544510c6f79ced53d457731d11b6b0cafe353cb9b30a7"
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
