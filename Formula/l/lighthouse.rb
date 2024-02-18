class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "de3186df8f41077968aa5ce358837858e1142a3c91877ca2b32066e4002dd9c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b0843cb883891171ee539ef2cc5dbb73b31718fbd2c8ebef9db040987d0b638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30f03a4a9c59e76ea6b21a114ceee6c245fccf6a9f29ebb21577877ca001ab40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117bdcab8d422e28b8dc1623b14d7e8c3cb0d90ebb9e469d586019df759f2de5"
    sha256 cellar: :any_skip_relocation, sonoma:         "74c8e875c5336da60d8b622357f4b59b519ef5fbdc41d0e306434357cf59dd14"
    sha256 cellar: :any_skip_relocation, ventura:        "33ccc647574aef9729f5e988467d5645b2cc9e50139b5682ba6f790a30de4926"
    sha256 cellar: :any_skip_relocation, monterey:       "d182887820f6a09f1086cff31024cfd688030ac5eb183a0db5378d55b4eccba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1328080c6b18bc7af0eb02d9ff3219b5d5f3f7166726c9a2bcc064ffa7f8f3c3"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
