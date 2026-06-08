class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5a2cc76aae7ebbc691ac5705749c254c95fda1c423418da9dfc869503a4229a6"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09673dfec36162105f0b4862e8fe7e2ec3ce00a51f056443d7ead5972fb822de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfd28dd258e464e1b31ac3a2921f355a48ce267f30b01b5676e06e411e62884e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e17a4e521d560f2501580cf447cf5452290b7154ddfea0339a2bfb750bab08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee72d21142f09d3316c3a98f5ef993c98bc55f76ca09fd31adb0fafc8d9dbc79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcf810b92e598c45a5f71cb2e236bbcf5cb31026982cbf21f849d062d6297f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d254783eec727228983659f48e79dc5263248bbf8f7b4eb8b26c043f45e2065"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end
