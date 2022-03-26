class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "05fe3930f5e17de90ca15e515092055f1d3db5f2481ade0861a8bcef9e006c0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fd43c5718b336b2f91ba874320dc3514ec9927d53931e451fba4db22863454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ec5a6e1da0df92f23cf7d799f772b550567bb236438770e2a6edce8bf39c60f"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa6ed1f79d7ce9fcbaf2ed04989b4893329fbddcdaefa448c941ab9077344c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "60444297fe6bc7e2c3af4de2c417cb2903514a2be0e7358c20550c572661e56f"
    sha256 cellar: :any_skip_relocation, catalina:       "d10f18d8a4a2cac97cbe82fc017aa5f4730ccd64bcb4ec19d2d75b7d811e1535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b652a7aac81c0f35d21d7d096d3584d63caf839cd69e729f5f0bfd34427510e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#(?:\\w)+", shell_output("melody --no-color #{mdy}")
  end
end
