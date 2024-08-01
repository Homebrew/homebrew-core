class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "96e40ff639015e23fe7b1d72f746420e232019e59a0c83c0b822c799752e81ba"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d892135a03f615db1d585de0791955386aece0c2a9939594cf8bb9d190bfbbf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "801b8b1fdcd448b17638667ed3d7b5969a1063191ca662c09121b52967795915"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e7d970f02caa250d78c49acfe530e3ad838b936ec44f5f80d0dd77f37310f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e08d1e334f800472f31e30d0c45d0e78a320127c96f7ebc2f689ef4b942b1ba"
    sha256 cellar: :any_skip_relocation, ventura:        "536dbecc539c08ece5ab74af7c38f5c870a81c42d2c09b28ec3d13d21f550a9c"
    sha256 cellar: :any_skip_relocation, monterey:       "69ddf68ec4cf857e819cc92c43c442b38fc80930d48d0525351a85855e861ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1709a82e2d588be0d98358ab75e16df3b70b0f1ad59da611496bddef169903"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
