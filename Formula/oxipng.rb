class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.3.tar.gz"
  sha256 "431cb2e2eaabb3ebe06661ad84bc883bda5500ef559608487c91842a0ae76ea1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de887c99b435d7f3c8a5567b0ea9bd68b2eb3a9e7095fc6f68261325aeefc4f" => :big_sur
    sha256 "264f1ab92ac0dc6595d395a52fb32c0fe0711a9592d80d2e7c00584ce5f15e63" => :arm64_big_sur
    sha256 "84295509fae9c40435518c4fa5ba2e2b8ed45b271e70a2ecefb21de5c091e177" => :catalina
    sha256 "9278cd1e4ce418514c4c34b3898371c360ed770ed583c6b9acfbd39c447c5103" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
