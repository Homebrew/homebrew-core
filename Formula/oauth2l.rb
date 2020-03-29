class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.0.2.tar.gz"
  sha256 "86dbc2cd0952db7e9b51cb41852f795488ecaf9e31c7ac8e0be54d719f53ebd7"
  head "https://github.com/google/oauth2l.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cc7ab09462ced7fde59421399d9a2eaa6bdc6a7c223f82ea6c2998961ec690d" => :catalina
    sha256 "7273e656e6e6d24e0a2e0a1a2e21e4fc9704b03f0e26e4172c2f51ca851d441b" => :mojave
    sha256 "950e998aeae2d56005f4c4915f05458d1a59715f024811e6a70eaca886aa8aaa" => :high_sierra
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
