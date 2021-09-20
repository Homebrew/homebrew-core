class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.6.tar.gz"
  sha256 "326cd5cf1875c009119691211f9b79aa55b0743cb51e69fd92ab9a4c2c3588de"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9a40d55b4a190ad6c94d857814a08760d6e6f43a86f4af99b729731ac2e4b2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e0576d03c790186e13db7f4d496ce8370e6076ad81bc71a0bece7c51721e1ca"
    sha256 cellar: :any_skip_relocation, catalina:      "27bd1192f54269b89956f03bafeaa488b4adbceac5c25ffc9da084c6a6831a77"
    sha256 cellar: :any_skip_relocation, mojave:        "34a13093216ddb15d08c3c95524d944ed9f76471f46c2a6878494cd23a48eb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e148b1c8a16e6dd00d0b72e02206c98bac776e279b93a1aa850e18dee2ef81fe"
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
