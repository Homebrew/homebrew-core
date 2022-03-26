class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0510cf0171782493348650f754c2089b279fa73d0e6dc13bbe2310228cec7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d62f93b6ba4ca88798e510ee70fa66c2c4b280ff20eabc5aaacc59166b3a83d"
    sha256 cellar: :any_skip_relocation, monterey:       "87dc8cec680436c6f0f2b7a8c93e59df2c7f06791d54293d1db14cee1b127b5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb5667604590e7f7aa5675866b03bba8cdb8649dd32f543a6853d70ca2d9ead5"
    sha256 cellar: :any_skip_relocation, catalina:       "c5c82345a6556076b1dd30e2b80ac51936ce8a910f4013f685b7207a7d9589fc"
    sha256 cellar: :any_skip_relocation, mojave:         "f618a86f7523021c5ca54730ea6b42bfc74d73a6d5e6a730e7f4d2b0028c2d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88bd1d09f07bd61e3c66f4eb6ee4cdfe8c2a46a453d18dfbf0fa8484885ea9af"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    bash_output = Utils.safe_popen_read(bin/"authoscope", "completions", "bash")
    (bash_completion/"authoscope").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"authoscope", "completions", "zsh")
    (zsh_completion/"_authoscope").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"authoscope", "completions", "fish")
    (fish_completion/"authoscope.fish").write fish_output
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
