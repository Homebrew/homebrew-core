class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6c02326d8bba708c177e946f59b3074609f27eb0250e74f52760a39360aff7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51d402bcb2a79225d442a5d291c1eb15d6899c0088704bf2ee7c919c2ade0e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "751047e5d1259f529ffb995c0199724dccb34a7892418e2ebd9fd9c60f16270c"
    sha256 cellar: :any_skip_relocation, ventura:        "2bd8ef5edf11158e2db3f871e13c683654ae7137ca6384576f25bb6dc3014994"
    sha256 cellar: :any_skip_relocation, monterey:       "cd8c5b3960c3474bc2ba1b404116d2e682ae733d699b87c41cc38cd95b5074b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e866a906027911bc7f543db28c38cb1ae952f30e51beab743e0b3243f1070ab"
    sha256 cellar: :any_skip_relocation, catalina:       "977e84fb35259cfc01b4ba789bdf86270675c031bbc9b289034bd9974ca9d9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf7f5e3bc8dbe57cc22cd6bbdd5b62a7c69c54e1da1cc6ea7e1e19b0166c413"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    generate_completions_from_executable(bin/"authoscope", "completions")
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system bin/"authoscope", "run", "-vvx", testpath/"true.lua", "foo"
  end
end
