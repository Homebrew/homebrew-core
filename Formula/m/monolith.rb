class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "51769e6505d5708ac296e5d93e280c9fefa7873452d471c5106aaeb7c3667f9f"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8add25f488753d8a34bcc51b3fa165788d5ebf32ad90ccba8fe2aaab0293247a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ab9ecc0569d14a3e88d260a59e7c5e224d287d4c5c8845e50de25fc8cb7fc9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39c6a4d727b1e5a295db251c3cf4dc7f6293648c1edbcee23d4cd44fda350495"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97bf2afafa039b7ac7fb576efe1067dd669ca8eac30634f0defae4d13f326a65"
    sha256 cellar: :any_skip_relocation, sonoma:         "84a2e97eb0d8709cd61f2ac96bbde95bcdee65234ff48816b38f9d70e5e9f759"
    sha256 cellar: :any_skip_relocation, ventura:        "d82d1646266dcfee5c25a987152a7765ec689e4335991f2868c780207e246e15"
    sha256 cellar: :any_skip_relocation, monterey:       "8b97aaeb90d8f53a8467bca19b27984e2edc6b4bfbd289563a80c0f5320a2ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed61ceace599a74a98a764b29b5e86b5eb39a290ad831b093f8d1ab40222c31c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
