class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.2.1.tar.gz"
  sha256 "25b1ab24fc68340b80ed701cb9df80f29b6772bf396bb0d41a21b456390a3de8"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e43102194b8fd865596ef85a9d9bf1fa96af822c2256d583d7f93eb26b373eee"
    sha256 cellar: :any_skip_relocation, big_sur:       "9dbc4d648806bf8a221bcc05378d0564df0fdc4044df3d9469f5d4c31bb5bc16"
    sha256 cellar: :any_skip_relocation, catalina:      "ab36e10cc3c194b92e740ee036b4c85d997b0882bd6a259ac155ee75fc363dac"
    sha256 cellar: :any_skip_relocation, mojave:        "2268593a0102704a2ba8f4d83e81702bcff3f9744a9c2ff7ef57a39a6e768c54"
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
