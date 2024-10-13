class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "77bd269073807731f6b11ff8d7c03e9065aafb8e4d038935deb388325e52511b"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6fb8cda3b694eda4c0a8869eb3c87e06007c4ec85d6eadd0bcc5bc3d13c0db05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccaf3138589f7378e7fbcf5fb30a2fc9c2d5ac0a6e2caacd50f69e5918d1719b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ec1379d7d5378af1ac82ba694e6de7bbc4cecd2f3ef6c764319289e0543dd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7257a1daa4372d40f359b43243d30954367e52b162ec27893175fdb1036602ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3093c17684dda91a5b4bff1096fea38eaa7d5167326e93143b32afb1ae090cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e5b28337c0272c443e96387ce6f339fed9aa0b2a064118df6b42840ea7f7292"
    sha256 cellar: :any_skip_relocation, ventura:        "0e43c89b55909edbe4d9afe85c6da8e6ae31e148ec91ff494eb7e4a3115fd4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "08c2a197781b175611f446838028d3a9c23982c0d6031af98cf6408ebc24a6a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "468ec8c830e8cb239534389e54eb086a78b5b4b9261ae0a174a2ad40cfb792d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c93bb362a5b6c22590afb2ba44ab597ae623cddc650d8bc1a65eae169c43105"
  end

  conflicts_with "go-jsonnet", because: "both install binaries with the same name"

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
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
