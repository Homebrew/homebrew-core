class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "2397c3e4a08125529d074bc5dce06a460b8198c2d91e762a01e4a53a7af6e303"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "60c733a4dd7d4e05f6c0d310bfbdc050fb48abc7eb269bea5dd377b582a60453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f6410f80ce8b524f4ea662342ea4a472681d19db953b5fcb7a913c2a8930870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c71e443185fe2c0436101823f23f3ef9e838d289bd8003abf8ceab8c0deb3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db2b59247471dbd9b6d1dfd50e4448d2a6b6c023a5020e88bc01c7e26b9926b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce1f58e0f96717cd749dcde834250fec15d8533576bb81dca81be2a29de57a5d"
    sha256 cellar: :any_skip_relocation, ventura:        "c9ca627df177c2b623061ed3216666ad1e5fecb66075d8c87bcdef8eb80884c5"
    sha256 cellar: :any_skip_relocation, monterey:       "eee22a5b051c85625c2d76e2c405b934da966f19b4b106ac86bf6eb73d970c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bbd306b0a15548673727607cc23a3b09212ee73998cb9de8e713791ad5d38b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
