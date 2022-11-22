class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.7.tar.gz"
  sha256 "0704abbafa93a42fccba65b9aa77caecd477fa0df4e28a33a453aafe1a763ee0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "874c802e55f459ae4c6343e8f72f2873032953924b8dc8bce7cb7517177ed3aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4ff5df9ecf07b72d8f6b99f15e12cd99c3cee6c352d39e2750698e1377da9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04841aa677c4ad464befbaeab4c3136c3374cacafa9825a6cca0c680182fac1b"
    sha256 cellar: :any_skip_relocation, ventura:        "695b9f147638d075bf7385284d5acdda56e8f15b3e170120ccb5288cfc1ecdcf"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c2fa8298c4e081553c2e66da3c2ddb3621586669923c308dda9e9cd523b51a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e99f7cc4df80c9762337508c74d9fdb480a32f5b0244c3334c83576cefabfaa"
    sha256 cellar: :any_skip_relocation, catalina:       "52e5ee16780c3bd439b4eb04e7b78f32156b3a84318ee0a4fa15c0bc966896ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77a26530535fd9963ab702b52d328928c28b8ecb0753c7206c6981b0ebdd6ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
