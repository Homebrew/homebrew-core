class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.19.1.tar.gz"
  sha256 "3beae1149bca2ff9b2958b97a0246536304d3f6769dccbc418031c292ab4392a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0c8b22de0e4aaee575591da02a8547deb6bff332d594691a4e42d70e6d44bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e1b3124a2b53732b4c6f48a6f715600e1ac5bd7c25a960cd647024f560c696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820299416a3c486067e936d56f9f1d8a929d66a8564e346969c187f9c13bba08"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa31a6772291a3aae5cad1f8d747f5dbcd9abea8f459b19b56071f944722bbea"
    sha256 cellar: :any_skip_relocation, ventura:        "b1213d3c7cfba497cd323865069e29cc46648bdcbf7a6068cf39ef1db9d85c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "ec39363017586f9f5516d7a15c1024a70b2f8a8817359e9d4ef0b204547980d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69906894762e10be4a5f148490437ccf393e6eaea609d7df7af5e9173c4d4455"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
