class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.7.tar.gz"
  sha256 "4edc54426511c451d9e7a61112d93352d68f7bb9e1dd472dc5647322c3ef78e4"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ff42b7748dfdabe0556a3bfc648a596227740036153d6e02416bf6b8c5c5dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f187e6e8d52a02af724ce93186d7bf80345150786eb826157f578be69cbddb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87bffedb799c6efdec1bc382b34ec564f63aa4abb28fcfb5f38df24072590997"
    sha256 cellar: :any_skip_relocation, sonoma:        "363bd1595d6f8ec049c69ca44327d92631c06d40be8b04bfe3ae20dea41a8a2e"
    sha256 cellar: :any,                 arm64_linux:   "820c1103f591573246d38ccfcb9ec9200306d70872550c0e9795210e0f89e5a2"
    sha256 cellar: :any,                 x86_64_linux:  "2b0cffc0e0aa65a253da206e183988473a39388309e77cddc640ba7bf65a1032"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
