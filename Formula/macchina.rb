class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v4.0.1.tar.gz"
  sha256 "6b2fc30a2ba8728f6608ec402b9c41f79f4c7753f40d505d4c93ec491671cdb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7ef30401564509d8174639b072d4b6327ae15bbaf85db1185068c6bdac51572"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3caaf6d74ccbd804c89a3c0c40907bbffe5adba1928ce09af484f7bb5e41530"
    sha256 cellar: :any_skip_relocation, catalina:      "acef15fa353c042e883c845b32f0942e9eb7ecb532769a09e88f111df0aff7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531362be3d591c4ca728fcdd74aafbba6652ee5b5a1f95c7b80e2eaa341b509d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
