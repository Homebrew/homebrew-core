require "language/node"

class Beeminder < Formula
  desc "NodeJS wrapper for the Beeminder API"
  homepage "https://github.com/malcolmocean/beeminderjs#readme"
  url "https://registry.npmjs.org/beeminder/-/beeminder-1.6.5.tgz"
  sha256 "d07ac749b24e402e43610514a47a740b6bb659ef2a08ce888bc83dbf008380a9"
  license "GPL-2.0-only"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test BeeminderJS`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
