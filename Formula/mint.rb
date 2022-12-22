class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.17.5.tar.gz"
  sha256 "f55350f7778c4ccd38311ed36f39287ff74bb63eb230f6d448e35e7f934c489c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fe1c5f8db79dfa97fb36ec9646079f23a18441dbcd83cca9649f2f59b4fe593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1797a7a9073fdd6900ed06e6e7305add5c5a62626947913c032b528bc4543c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d91ea891ced7d9c9927f57898c6d3ae7d1056410c99244ac60e6efcb642536"
    sha256 cellar: :any_skip_relocation, ventura:        "c3f28c2b81d7da7d93b0a67b0506efce2bd485e9a01f9d81f560b9fe93b85ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "771fd3357631887772c69a9340cbe88f9ae488458270b3491b683fac0aae4685"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a257fa4677c1cc00b53290855874700f5b39eac9e4c90098627549130b01747"
    sha256                               x86_64_linux:   "0b06ed938d61bf55d577b305cddd1fb43081d1f8d9cb06e8b2d5755daaf7fbda"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
