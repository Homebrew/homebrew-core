require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.7.2.tgz"
  sha256 "a9fc1dd998d34de8f4300936ef4e422d3aeab086930a34f1e5ae75219a1b8f58"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb4a7a4ad516f0f750c27cac69245823565d4240c5b3913bccbddfa7f3d8e568" => :mojave
    sha256 "b122d6e652f9462bda4560d0b6d19d520ff3f9520818a019d063693894ccf4be" => :high_sierra
    sha256 "b18d54ccc94976e1589eebd2577b5d03084780101d750b98f9fe5beb8904c586" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
