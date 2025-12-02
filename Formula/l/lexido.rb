class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "c39cf8f93cce2480773c9099ece1d8a90c1e350cf48cad56eebea96fbc04981f"
  license "AGPL-3.0-or-later"
  head "https://github.com/micr0-dev/lexido.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a371b288b7dbe8326a99383541cbe1e3a3f4ffc160e9b3a7db5f163af83c906e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f118ba60cdf4e4e921ff03359e5e57e481f6c2178e098cd3192305c1792ba054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a51785bc7e8fd96ff436d69daec2f2786a68e99ec94ce184d7e7caddcc84dd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca1e9acbf1452480bd301384bc7b9ac24a3465303cb8466edd0f81a2e34b5f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4956489fa0eb3d6f1df286b265bf38740151b82fefd1712e7be166f611128b2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b7dd651047def2a657583caae2eb6210bcbd838014f5d305e07f847a5e51206"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2c3248e36b02b6e0fa26b5a200874d2c92d426f7675bafbda92506d69abdc5"
    sha256 cellar: :any_skip_relocation, monterey:       "38a2ef2f276bb0874d48c8ce96b783f3cc6cfe489df34cf89c81b1b9894d1001"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c786e8e845f44cb47234afab474ef1ae6a0e6afb9b09afdc8f334f86788c5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a7971e9b13dc59d9539c08bef80de9abb3873743315c34a5a95c640a4f5a5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Run the `lexido` command and ensure it outputs the expected error message
    output = shell_output("#{bin}/lexido -l 2>&1", 1)
    assert_match "Error initializing ollama: ollama not installed on system,", output
    assert_match "please install it first using the guide on", output
    assert_match "https://github.com/micr0-dev/lexido?tab=readme-ov-file#running-locally", output
  end
end
