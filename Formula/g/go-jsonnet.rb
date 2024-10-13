class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "bf9923a848dba65fa99f6e926221ab4222c2f259ba837d279b43917962bc7d70"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3bc19e31a7ea1de9376c90135df48fdd8ed498f594dd0f7916dac2f41b5a2d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eed7e4575bf7d5222f5d2e40ab27c0fbc5ef5a1c06cb45bb69a84060500a8cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ef4c5d8638c9eb8197bd5be4bfc1e1e52d6dcb7275fe193850b4729ca199af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f6ee690b5458c98426e668d40adc3d9f392b1a3d66a084eb5661dd032ba25d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "047317978d20c496cecfed47b54268962b041ef4599de8d46218f382b2ff60d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5890f2fa8484a2b9492ee5a0e95aba6231f0c62bdbc5541297b95856a3586d75"
    sha256 cellar: :any_skip_relocation, ventura:        "0cb7c6f14e4d80552bb290c3f6f9cfe564ca46c37756b14a86adf0ddf671e146"
    sha256 cellar: :any_skip_relocation, monterey:       "ad1d51519e7a45af2b8132258360965ca84d7b9e4a36ea30dc5b708682ef06d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c11c053543e2d2bae86497ceadb07ebd78949aa4822a7061757604a920ce3e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e4b46c874cc4019c247df166cf633df2dbf0dd77e8046aae0cb6594c49cf4b"
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
    system "go", "build", "-o", bin/"jsonnet-lint", "./cmd/jsonnet-lint"
    system "go", "build", "-o", bin/"jsonnet-deps", "./cmd/jsonnet-deps"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
