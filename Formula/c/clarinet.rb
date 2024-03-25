class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v2.4.0",
      revision: "a5f9fea72230b893a7d1f90bdfda3a68aa48e908"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "249a84d4d006734b8371db086372595d20cbcf34d1d5f439c1ffc4a48864a435"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b14bb837198072310d7c90c584adcc28adc42da3c770d4854fe9788571404905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a0437dc4d28b85ed3f920d2f478b97141a00684a9a256a87dc55c1c0504980"
    sha256 cellar: :any_skip_relocation, sonoma:         "405e9dd65c762bacdd0f18bb9aa2cc688e436c1c98239d5f327a9243ead3f743"
    sha256 cellar: :any_skip_relocation, ventura:        "82997f557bc114b8e6cf130b6422650a41a1c355394b2660f7263b8b8f15e7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "c144ada83889a3d4b1200b1e0a95f2b259ad8c2f08b95f8f17dfff7ae9b94df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6dafb4011d7944e0d20094bdc34774401c9b4b184c6c4bacce4c9971bd8da4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
