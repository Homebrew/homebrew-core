class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v3.0.0.tar.gz"
  sha256 "00edbe20dc18f80b00f96dc6389b15c90c9f6068b207d3b282cef3c75fed0fe9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4759675ebff3a724731ec4bbd0337f18ba374e8e531d909d36a489b54fbf67ab" => :catalina
    sha256 "d08d638656c7d0da5beedbe2500baad21130c34a736947bbade377ad2ea5c406" => :mojave
    sha256 "3cbecc354042628174c5dfce4eb37984b1a6f9b89f7a54864af53cdb1e86dca0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
