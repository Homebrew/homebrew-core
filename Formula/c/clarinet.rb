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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d71c0485854598e1e517b938f7bc7f7c459f2462c940e365b113b23bd5359cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1e78623c924cb9656ae5695539cb21b430f75f93610145744ce978bc49233ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419cfeafffe453921df2342905a220006dab0e1f3994f641b0e8ffcab810acde"
    sha256 cellar: :any_skip_relocation, sonoma:         "b19c57dd438078d9e000821e6cd1a9b6ea93e978b5a44a876588f60136d8fd8e"
    sha256 cellar: :any_skip_relocation, ventura:        "cb9c1728653a9e8730abfdb179e60280d64a5db4e2f0cd0e4b3fe5cd417b7678"
    sha256 cellar: :any_skip_relocation, monterey:       "c063086461eb5c2dbb8e423413eb4a6ab702b667171d9eab9ade94949a226340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed762bfd8088c2b842aca58478d92173840a0d804980145d8d5c4c40d9d7a48d"
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
