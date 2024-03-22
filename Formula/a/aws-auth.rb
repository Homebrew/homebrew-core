require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.1.5.tgz"
  sha256 "525f3245cfdd011e0e2e863f602d565e8744d2e04a858f0e875e82cb048ccd2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, monterey:       "cd2b8c8e547b91e74fb410f970363523e672cf385c0c51f657ca77d5b436eae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e75be4bc68be2b2252563a8a45acf27b275b19d759622f3b4e30f82a1a6dbfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn("#{bin}/aws-auth login 2>&1") do |r, w, _pid|
      r.winsize = [80, 43]
      r.gets
      sleep 1
      # switch to insert mode and add data
      w.write "Password12345678!\n"
      sleep 1
      r.gets
      w.write "Password12345678!\n"
      sleep 1
      r.gets
      output = begin
        r.gets
      rescue Errno::EIO
        nil
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "CLI configuration has no saved profiles", output
    end
  end
end
