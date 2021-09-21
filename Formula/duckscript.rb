class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.7.tar.gz"
  sha256 "b2143f0f4660eb61b43da440fbf1c43e2bdefefc657435187e031b2fe671fa22"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53011ab092b1401321cededb4b94b86b7f4d8789e78274a62c876fb39791b92e"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf71ba296c39376113500d28e513fbcc89317ab0dab9c080b53838c9adbf8e5c"
    sha256 cellar: :any_skip_relocation, catalina:      "46fce5a08d36bcbba67fb127bed6422714593336ee2ed921544cbe8639616bd8"
    sha256 cellar: :any_skip_relocation, mojave:        "86ed6c2b3fbb3135364771765411f93a2ce468929fccb82ac3f1046a18099f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d908c950d691c8a63925ebdf75a9ba005ca9b538f7d67b64fa1dfede3b4aec30"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
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
