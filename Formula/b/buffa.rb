class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "318b363643469c50517cabed7e28c8950f895457b1165fca84f09ca884121d49"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe82829a739811b15b0914d5e5dcf7be41cf3ce36d1158139735a134576b0695"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b807cf70c5bd86053ebbfa1897e43aedd0e51d06cd9160ed8c5822a9081964d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec6ad62b0cc128a17df0a4ac48786656fc3faf9b6a8901eaa3566b6208c61ba7"
    sha256 cellar: :any,                 arm64_linux:   "1725bf3410b18bcc15c6ea776676a10f3af230360c1380951f2372528c78a762"
    sha256 cellar: :any,                 x86_64_linux:  "1620609ab8c7cd14477d169faf81dbe1b4b1c42f04f06591cab44c5a16e79ece"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")

    (testpath/"sample.proto").write <<~PROTO
      syntax = "proto3";
      package example.v1;

      message Greeting {
        string message = 1;
      }
    PROTO

    (testpath/"gen").mkpath
    system "protoc",
           "--plugin=protoc-gen-buffa=#{bin}/protoc-gen-buffa",
           "--plugin=protoc-gen-buffa-packaging=#{bin}/protoc-gen-buffa-packaging",
           "--buffa_out=gen",
           "--buffa-packaging_out=gen",
           "sample.proto"

    assert_match "pub struct Greeting", (testpath/"gen/sample.rs").read
    assert_match "pub mod example", (testpath/"gen/mod.rs").read
  end
end
