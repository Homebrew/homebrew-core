class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.31.1",
      revision: "f29d05926195d86123c29733790a516b40ff7b5f"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b291c67cb7466697a02d9499578855635b9976918accb9f7fcbb2b90a3dca6be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "421cda5bdd84a3bd955ece425e25fc1eca008dcf43d02c92d8af25b888973f98"
    sha256 cellar: :any_skip_relocation, monterey:       "26dcc49e1f9143b4988961bcbdf75c8b5b020791ad510d36bdc10677de794545"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f689ae522a320e8e574a2b728a85bcf46c6be24fa4cc61d12a0eb585119bbee"
    sha256 cellar: :any_skip_relocation, catalina:       "7089e852a4e593d22c6e3873a2ccda2a67bdf0be3948ee3a53fb4f9b6b06f849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36559b0e9d76012606e3deb357e6398c0bac95fc1c1124da8b68373a3a9dd52"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
