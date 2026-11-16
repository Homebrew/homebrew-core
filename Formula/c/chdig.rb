class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.11.1.tar.gz"
  sha256 "c385cc9f1aba57e49aea577ff0b68bb279cd5d3366d90074e4fa4a67aaa2b499"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d9892db7abde56cb8885a58a2982c68b537347267065b4dddd6f951e4bfd194"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7c1277f91296ccea8dfc1c1b18f98fdccf5cf8921982feec8115482e1b00ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d95f24fb80a3ea532b50fad4bc339aa3a01fe1d1ff7e8b677787c19577497c6"
    sha256 cellar: :any,                 arm64_linux:       "6928d98e8fd440aa79ba9ce9072a66cd8ce86c270f626c2efcfdd0c90010c92d"
    sha256 cellar: :any,                 x86_64_linux:      "ea803154958452bdd397ed41378e8348f15f2c6c7f8ecf713359a9a29b619411"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
