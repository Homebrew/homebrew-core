class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ac67abf42b3f86f39d3cbb3412049dceeb7a3f83486435953c7c6e8b44d23df1"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "oauth2c"
    bin.install "oauth2c"
  end

  test do
    assert_match "User-friendly command-line for OAuth2",
      shell_output("#{bin}/oauth2c -h")
  end
end
