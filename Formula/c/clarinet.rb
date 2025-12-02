class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "067a2b0756642a9460b418f2af7ce4de3d9740de6365d5b11cd6e2cb73de0c86"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e3573d2b6ea8ea28feba0b4ad25ba138dcbe12da663ad7405a42d0a358f5fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70aff6828a701c266bd59c1694f2beca0e88420935807c752a961434e3a494c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df92a9647a0b78969edebb22504d22acd4596747bf2b968a9cc61d43bdfa6ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e3581da750d121f92699f1bdd6e294423574af0a2eefbdda77b0ca6d7e1208e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97cadd1e86385f7fee099574627a72bfb233ffb397ff9e3135b70ead3e7e7bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db51efca3e021f7c5c07a44196e1ee9f5b5161ff7ec6b59179a3c998c448a848"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
