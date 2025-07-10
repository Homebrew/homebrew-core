class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "8cd4eb4f60c0e933437318a41d3d9c3854d6d4a3488c35c873508f11aabd270f"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e8f95560c7af6545b67f53e835bcce5f282a70aca156728a19fc081b3cadc46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc12133ed1f0b2b2f3bf52ed4dce36dab2c5230d8c7806f15c3f42f52c07b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9006e9578e085ca57bdf60f31d8387a853baafb92c8564882c4d93f0601df6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c529953a642ecd9a05d258d2c1fac83fbf367208aadb674edfe451e0721c0d"
    sha256 cellar: :any_skip_relocation, ventura:       "58946969b1a421ccdf9d7bdc4df3ee62a897a8d354091ab0c3fcf6ce0e66697c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b10a50a8d623d5bb3b017f3229da2324b7d459d08232288e9befa4ff7a347b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a90c38549ae8ef1003003802ad63f84559b2578e02ccb4283573692a595b38"
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
