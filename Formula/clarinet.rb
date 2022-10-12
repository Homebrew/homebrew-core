class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.3",
      revision: "757804885f9615d54640ba263776a56a849828cf"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6502ac3a3acca30c132d1f180637f03aee5d663bbe6f678098bef7d734eaea77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6026ba803831fd1c325d333d58af174ea95cc82176029758e24c418683110c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "80849dba9315acc16c3dfe3e097f318135c23bf5e3c39c9c4410fbc943349ee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe1dbda4ab00273852084b08316afb1a77315d82113db9e56e651476db46b052"
    sha256 cellar: :any_skip_relocation, catalina:       "b1cdbbf32a51346beb37e553b8b60c86d46f8d5c40c22cf9af0e30cedc0dcaab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a35105d9d1b12ed748e60412867f42be758dec4411aafcd438fbb1c3dd8ad8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
