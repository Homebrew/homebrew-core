require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.0.tgz"
  sha256 "74e2ec4eb09a6db0a0b6a37927f5ca8efd6a7bdf5420fb52a76f1cf64be136d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6edecb90b98a3721512752772ed86408c7124771efad7f7844a6fc13e3354525"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78d7fb93e88d312e03e1fc83bbc57536d984ea4e3f64cb2710b19ea6dfc53f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c993945c0b09293a95b6b23ea14cae6a9182570b734f259dcd45f8ed0d1cc4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c69549169ec4c4960f4b0334ea8e7850f8ebed5e2eb5c9d4f1fb574153371286"
    sha256 cellar: :any_skip_relocation, ventura:        "4cb65a6d186caac97d757ccfba908ca8035659986417f1acdbf75f060a4090cb"
    sha256 cellar: :any_skip_relocation, monterey:       "558153ae9ae957dbfb8ecad5186be905e4e3e38ffe1cd444d2dcb0939dd934af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c962a77c8894bcf5c6eb63635ad44906a410c88914896cf5a5302c9f9a793e4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    unless Hardware::CPU.intel?
      rm_rf "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
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
