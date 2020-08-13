class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.1.0.tar.gz"
  sha256 "4058dc07fb9a4e985472068b80e9504b477102b1a0cd999f9367736a5ddb6be5"
  license "Apache-2.0"
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
