class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.13.tar.gz"
  sha256 "089e85cfe54e2bcf7018b32ccb6fe06bdfefc1f1b9f10ddb9a59c74a24c54c22"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9894aaa2a944976701463459caa60dbb3ecae0adc516ee5bc47bf3749fb21460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1644ebdf048379f0a8cd5cea168f17fd23dd031a6e36e13aa99fa6ce048311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e79e3697dd224cc2dfcca769ed639ce94df3ed266f2fcc940a6c87e8784a54"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c97de44040c97a025de6d34a420b8f3e8ea22aaa5b4c717db092fe05e9432a5"
    sha256 cellar: :any,                 arm64_linux:   "3ed29b0333aa4349575a7ac33f87ed45e53319ba6dff959a10f1cdb1891441b4"
    sha256 cellar: :any,                 x86_64_linux:  "7f38cb01c722b6a5a716c1c9ebddfeda2879fee96cad0ee8a281a20b2f59c8bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
