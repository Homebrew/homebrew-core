# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class OpenscaCli < Formula
  desc "OpenSCA is a Software Composition Analysis (SCA) solution that supports detection of open source component dependencies and vulnerabilities."
  homepage "https://opensca.io"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli.git"
  version "v3.0.0"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{VERSION}'"), "-o", "#{bin}/opensca-cli", "main.go"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test opensca-cli`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/opensca-cli", "-version"
  end
end
