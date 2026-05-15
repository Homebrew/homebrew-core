class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.4.0.tgz"
  sha256 "f1b4862a695b076bd4b9348c038366420bcf4f41ada58a4c7a813c4cb4303d2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07c21c41633e5ff853a03516740d6eeb0ac9668263cdbc17435b563bab38f644"
    sha256 cellar: :any,                 arm64_sequoia: "4dc9414629bf8871f4057f2dc7b59cd0da9d78f2b0270f82912a2a610446a230"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc9414629bf8871f4057f2dc7b59cd0da9d78f2b0270f82912a2a610446a230"
    sha256 cellar: :any,                 sonoma:        "2ebb0d00d516d163cf70d05f7bad1a156a6d59cba2ed4799a302a7e4d86a9e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f481d97533af8805add6e3b721765517b8a808d07465d209ef6a4c93371ce8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc02339069428358438179f2906a2cac1c3df2c27d327bae9141bb236b77bb7c"
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
