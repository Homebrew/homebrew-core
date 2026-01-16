class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "b863b1517c0998e4d73991d86a34036e52f765ba4a14f3d132fea40bb2d017a8"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04bec39059e2e7ae9acfd7d7353dd18b488509b4789433bf1de20daca1c5c6bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90bed2e6e4ad318e5c7e8c3a878dc1073bb1f3252fc20822100783347d4ed0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc79f767aa4dbe2a60de730350c44bf2317c042e95d04ab0a0252c82e8bf29c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9af54c26d3bede9541e4a5e90c8b0a6f4549c1a46f4118654b01987cf7b36c09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a9b1e00700ac9c3f53d99247b8f4caa610f1ec8bef9af90cc94fe7e17d56cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a540e892d0c254332bab28f138adc5670db813d402834bbe53fe06be858cf603"
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
