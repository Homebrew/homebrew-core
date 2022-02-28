require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.1.4.tgz"
  sha256 "e0d25fb35f1f1ba9e597d54f37ad2c5f16af85129542d08151e2cc01da7c3573"
  license "MIT"

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
