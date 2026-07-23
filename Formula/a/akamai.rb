class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "42d47d0fdf4c737cf0cdfd882877f6e91bf416bb165b03acbce5c3d82aada299"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0cba1b386b224c80b5be52e3eac7477626457cc5939713b12645c972e226512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0cba1b386b224c80b5be52e3eac7477626457cc5939713b12645c972e226512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cba1b386b224c80b5be52e3eac7477626457cc5939713b12645c972e226512"
    sha256 cellar: :any_skip_relocation, sonoma:        "446884295a157802ad1e88c9443dde229e8559f31df651b0a75f9d85838205cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4655009c7c9f9a9b568c62126402f968d79a57428fb7297b434ec913481850b8"
    sha256 cellar: :any,                 x86_64_linux:  "a8b646286f3e91de9a9226669ca6ded6eb5e8b4e5e19ab50abf93371c5f11bf9"
  end

  depends_on "go" => [:build, :test]

  def install
    tags = %w[
      noautoupgrade
      nofirstrun
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
