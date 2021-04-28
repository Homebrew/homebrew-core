class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.2.1.tar.gz"
  sha256 "92c0b08b1459f5957ad03f1424252a9e0bca6d03e542a8925107039ab9a7b564"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9a8b19117c51afdf3a6ca606ef9adb6d71c0d051b1457ae31ab2869ff60466a3"
    sha256 cellar: :any_skip_relocation, catalina: "8a2d42ab13b46ecda7be4ce08e2e38d2783089e29077815055e7554a20b987bd"
    sha256 cellar: :any_skip_relocation, mojave:   "fa326b6b7869e46f087edc41ff1308896dd224dad1f09ba895f3ce459853a5b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
