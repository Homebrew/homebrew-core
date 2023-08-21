class Aftman < Formula
  desc "Toolchain manager for Roblox, the prodigal sequel to Foreman"
  homepage "https://github.com/LPGhatguy/aftman"
  url "https://github.com/LPGhatguy/aftman/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "2c4f191bfce631abff185a658b947105055da687c409e09ea80786be4c32b75e"
  license "MIT"
  head "https://github.com/LPGhatguy/aftman.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50e5f064dab32bcb3fdd8cfa1609bcb00a5b16ca3282a135fc58fd6b8288e3fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecfb8ea7921a343d05bf4ef74f58b885824894092a0a734df9330af10c7eccf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7183b254b99b1af6ac3b32f6c44a80c6479b90224b7a9aeabc2aa6afa80ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "94ae85cca15a832dad6fdd5358b3bb55d754b0ace6cf7c104d3feda446310e02"
    sha256 cellar: :any_skip_relocation, monterey:       "0da5a65b18e6bdc91021265d891acd31cd3802c0dc1aa6cb7d04325d899129b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dffe9686eadac8783eb508b6b476e4c89baaacae80df526279696ac8c68ede89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01237e308408ad92abe2eaf21631b94d1650cea7531b58a0c513ad5bd8e48e26"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"aftman.toml").write <<~EOS
      [tools]
      rojo = "rojo-rbx/rojo@7.2.1"
    EOS

    system bin/"aftman", "install", "--no-trust-check"

    assert_predicate testpath/".aftman", :exist?
  end
end
