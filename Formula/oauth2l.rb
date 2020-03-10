class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.0.2.tar.gz"
  sha256 "86dbc2cd0952db7e9b51cb41852f795488ecaf9e31c7ac8e0be54d719f53ebd7"
  head "https://github.com/google/oauth2l.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36b8c454a7d8934b7fa5ba65ee4132859ffd07452628c5869ae51beedf010f8c" => :catalina
    sha256 "7983a17ea03db453152e87d1bf517aff15f4f3bced0bd483405e6e31dd6fd070" => :mojave
    sha256 "d7d65ee29295d7740068d32b552327a8f3ceed0b3eb378f3d06afcfc03fcf796" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
