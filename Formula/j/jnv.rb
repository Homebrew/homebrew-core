class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8220bf433728b57ddb174920a48c1750c5087b52154567074020b6800d6579d3"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "868d0e7996d85cc836e6c960afdeb90c99b169ee2c23e0070988e8957439cd4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdfa08801f21e518a4266af55108d88408b25dbf74a5dc454997bf973458ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6aa1d7c82025eb2e7f3bfdcc9a9a0f18b71336048df06cc4798b5d93f3fbd944"
    sha256 cellar: :any_skip_relocation, sonoma:        "462b69793597865aa518a58d74c292897b48a240e5a674bd27012de6ef69741d"
    sha256 cellar: :any_skip_relocation, ventura:       "fe8abec51096410939da83933523f5a2dd2be3f5eb5e7c3a24cebf7439ce6876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133259d9690645a87aab683e8d09a6e7f269df570f15cf6c91a427ca04f120d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bea05489eb962c26df754b18931fb62752d741db352789d64b4199ba666da71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end
