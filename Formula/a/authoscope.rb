class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6eaad5b4287b9e44492653bd7d5996f61c1b29d996e6ca4a045c6eb5019a10e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a49139a43ce427a0b371ff1a5e2ab5859c0e79f3738acbe4b74c17dd4cb8024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc1b377f452c89e3e436f00298de7bfe6bef317b3787cb0b76e3aec5d320338"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c9f02093d86f2a5c7d957e28204eb5bd6f42f97cbe8b81d4186231d9ff9cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c385626205475728c35fe60f4089c8167f54c4472dabed081391cc6c3801147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a73ecf5bcb046d8f4083230f5f425cbe918b7a792f8474c3921f7d2f1075268"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    generate_completions_from_executable(bin/"authoscope", "completions")
  end

  test do
    (testpath/"true.lua").write <<~LUA
      descr = "always true"

      function verify(user, password)
          return true
      end
    LUA
    system bin/"authoscope", "run", "-vvx", testpath/"true.lua", "foo"
  end
end
