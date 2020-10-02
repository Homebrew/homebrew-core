class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.6.8.tar.gz"
  sha256 "1773bfbf365844f874441fb4c76f3d63ef64aed82835b08d6fbf5128509d90ff"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "695b2d88a7f1905a2e94972d2e3560ead20bdbda501353bfaf438f5173644d9c" => :catalina
    sha256 "3740b8bdbe7696be29fdf5005b506ce9d27f16db901f0589886b3af8fb6af020" => :mojave
    sha256 "0089353fae5b1fe21779ab988e17d915de1319a9916c48869d81aac660d57dfa" => :high_sierra
  end

  depends_on "rust" => :build

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
