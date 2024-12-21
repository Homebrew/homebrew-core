# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Csscrunch < Formula
  desc "Simple CSS Parser to tokenize CSS, merge rules, and optimize it"
  homepage "https://github.com/gafreax/csscrunch"
  url "https://www.npmjs.com/package/@gafreax/csscrunch"
  version "latest"
  sha256 "e43eb9b3aee1fe737b19a930c6035d1fe4989bfc2488eadb83be6d98e0528676"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test csscrunch`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
