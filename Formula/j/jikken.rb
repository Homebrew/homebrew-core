class Jikken < Formula
  desc "Powerful, source control friendly REST API testing toolkit"
  homepage "https://jikken.io/"
  url "https://github.com/jikkenio/jikken/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "fe43cac1ddc90b3b4b39205b2c66b8f405984d121fc3fdb9fd29ab915e13abe5"
  license "MIT"
  head "https://github.com/jikkenio/jikken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08977b9623af344b43062e18859d610b5c793d87f565bfe956fb374d81a162b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a652a4be75136def2174478df62ca556b35f68a67f226050dc36a7b00ffdd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acf8f04492e85efefc8da9ecf0c0ee524e4eb368a065836f79eca328d2539ec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94968e28976a49b9a128bbd3c2154f388acec10939d513c2d01683701fbb69d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a2750000f3977e97d090ebd3509e78e25491c278e674f9dc9d395937d416737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b032ebd23fff994a41838e89201a67ed583274c816d4544ccb87262bae818be"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/jk new test")
    assert_match "Successfully created test (`test.jkt`).", output
    assert_match "status: 200", (testpath/"test.jkt").read

    assert_match version.to_s, shell_output("#{bin}/jk --version")
  end
end
