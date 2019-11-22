class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.3.0.tar.gz"
  sha256 "870c6ab802ca4df6d12a5570b6883e7e3b190bbe6e2fa91282af9b294c8e68b4"

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
