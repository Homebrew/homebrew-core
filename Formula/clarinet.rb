class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.22.0",
      revision: "c7fb497880f90e7dae2b04cb795978a6a1cc7419"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921482ebe720415852fc1dfb78e125f01bf7382a50a33ba47e96d75cd11c67ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd48897493511367b544494159f8b77dc76cf5375e054acd8246e43f891a877"
    sha256 cellar: :any_skip_relocation, monterey:       "03c52d328cf8569f79f1e7570525efa8ade092de4839255fbca7bacf9183a106"
    sha256 cellar: :any_skip_relocation, big_sur:        "41013a90f7e3906a418f83b555972483dedd9c3354117a06404d6ea5087b8411"
    sha256 cellar: :any_skip_relocation, catalina:       "8754ca69e10adc73bee986a2e907c9690881c44c98c70d86a44485978a6d3ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927da21edda357ecb9137f96aedab0f85defc92c610cb189904cfc09b112e33d"
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
