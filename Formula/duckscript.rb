class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.5.tar.gz"
  sha256 "e104e70aa16cf7aafe5cde2c817634d6384da242a4fe5ece15699919684a7053"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff9b9fe004a132ec37e3e9eff2d2e09c4db80004a295b408b0e09cd629e83dea"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5b4e1caf43415f96c4ada23a6c68fdde675de6e2989efa3a70253fa60c65e45"
    sha256 cellar: :any_skip_relocation, catalina:      "64b106dc9c6bfac3c7b6693d7c6ba450f4119f0680b7ed366d79f32693a457db"
    sha256 cellar: :any_skip_relocation, mojave:        "54c8de15fe0a18005aa7413953ac53ac92776b061ba12cc3ecb059d813605b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebb3f290eb3bfcbad263b04f2ccf26990f0893aab6f17a46b28edd7cc699832"
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
