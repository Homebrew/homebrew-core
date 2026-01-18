class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/1.2.0.tar.gz"
  sha256 "d618c59060b76fcff26c066c1a2385c85f8c808bc07e2a1f30c777255de2a400"
  license "AGPL-3.0-only"
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a5d7a59154b77080657cdd17b8c4cb989e34a060ad7f80d0c25f8fc6d6c3e68"
    sha256 cellar: :any,                 arm64_sequoia: "1064dc688e6184befd3497ae9b802897bf52d0cc21b02306914f6e0e488add3e"
    sha256 cellar: :any,                 arm64_sonoma:  "6e34ddfe276dfc008ced3815ade9654aa119627123a7b3ecc23666552890d55b"
    sha256 cellar: :any,                 sonoma:        "746c3ebe76412e059eee1843143b06d30a700c60fd85dde0c3726ec3e623a1fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe88a7ebad40b7381aa07238ffb91b74f4051653a8dba5e58f1a8650a1869db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2908972ed980846dfb43acd200e11e8a438273776ff8d20a5fc51141f787b031"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end
