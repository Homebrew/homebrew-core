class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.5.tgz"
  sha256 "43785466b4869a5df23fece70587c8362b281a27b24f33d049154cc642e15907"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c5219dfc85244742c742b03efc5478f0a38d6c9ad72782ce09d01fa34d9016e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5232b6dc732fbc8388e711a102da26f15965328681d2fc7b70eb90e9d24d404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5232b6dc732fbc8388e711a102da26f15965328681d2fc7b70eb90e9d24d404"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4d784581e5f642bcb0eeae52c7136f4d5dbcb2ccef689ade93ba0785f93c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e90e393dc527fae7998c590aa8aaf264b5c1066608d26db3f1748f88bcb6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2d481a8f32e6f3eb32c73ccc82007363de28ea39fa35c059c8b122b810aa96"
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
