class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "9e401f06f321c263375f939621075aced16c1115773ed0ec6edff70a26a1f122"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c86990c04c0c1973212feb056149992da31559a7785cfb36edaa8d680cc8f38f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18da11dd8ee3b15b593dc91fe2a5aac2abc2fa293acabadb1389eff3d0898eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1932aabf67f74bb41086096ee8a87dc1129f54b499f46403ccbd744db92ff54d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba54e91d4e2c5c3b3e3dbff06f8d480812513c9204c2821847bd201bdefd32d"
    sha256 cellar: :any,                 arm64_linux:   "8d0e5a766b87a835881e2d0c463d69a8eaaf6fab3f76749719f93720f65898d0"
    sha256 cellar: :any,                 x86_64_linux:  "9dfe2fbc6a1e6940df52a7391de7ec68752eac1b26370259229a659aa2a8fe81"
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
