class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.20.tar.gz"
  sha256 "126de84f2cc03cb4ed8e835ed571dc2433ff15db7c558ad0c9455d87994977d2"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2667af49cdfdafe3f1115280adfdcedc2e9fe9b3053bc2eb03a658e859a82ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1230e098bce64a0bf9190d9ad2171f64b80b3b29ce31b5c009e02779a653a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "186eaa2970ab0cea315729f5492aa99c285c24d9261fac505e674754526611d4"
    sha256 cellar: :any_skip_relocation, ventura:        "f05eb25e79cd6dbfeee3fd7fbb93ec1cd8c9bae5bcaff9a1948dcf3a9696a68f"
    sha256 cellar: :any_skip_relocation, monterey:       "5d7113f6cc7b63d6ccc504c3ac921561153d4e9d0e51fa0bddc1516b7d4d5e88"
    sha256 cellar: :any_skip_relocation, big_sur:        "63734ea36b9ae620d5fa55f88ea8f470b4cb72d63f3f8fe28a7f7555cb5f9281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2ca9501af23dbc06e2a97fe7eb16482a0963173045892be624399d7e0e08b7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
