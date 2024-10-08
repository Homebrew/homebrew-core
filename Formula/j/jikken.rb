class Jikken < Formula
  desc "Powerful, source control friendly REST API testing toolkit"
  homepage "https://jikken.io/"
  url "https://github.com/jikkenio/jikken/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d06d1bce4715c8d64d6f4c59bd12f0e7f18b4f486ad04eac9ddc263f7fc986d0"
  license "MIT"
  head "https://github.com/jikkenio/jikken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7053c50fa712a296f1eee21d4d42a61d67673793a63a086d3157c0b7288fc495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c23b8ff7ca5ddb70cd64ae101271e9579d65ec0f58f870beed1f6ab031b80a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b12de9d9fedd822f1a83f9f53292ed4ae06062ed516053020788001bb2ff83a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f498233653cc37842fbf468a1ea331354c8564ef2627df427f6ab863664b23b3"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec50d09c660996034c199860024ee493942ffff0c9f1204509ae5da102a3731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1426535008b954a0bf74e782b283af27a28eca365dedb5b92d0acf11d73b5e4"
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
    output = shell_output("#{bin}/jk new test")
    assert_match "Successfully created test (`test.jkt`).", output
    assert_match "status: 200", (testpath/"test.jkt").read

    assert_match version.to_s, shell_output("#{bin}/jk --version")
  end
end
