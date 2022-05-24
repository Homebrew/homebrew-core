class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f91ed4573ad840f6838d4404c83a0f033b22e92c14f9fbcff515bd8bcf06923"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1056a76b786037d9c7a1cbd771c166d401c73bd09a376dd70c62b84198b70700"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8a040107ca7a409bac145c058004f4d7bba78189460743f093a27c7632baed"
    sha256 cellar: :any_skip_relocation, big_sur:        "831bd7db66a990bf4c5abc1db37c133219bd2a1eded1b050edddcbdc4f78142f"
    sha256 cellar: :any_skip_relocation, catalina:       "c856e4e6681562182d00fee6f9ce184579ba814fcef9a51c8619b5350256354f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c3013716f7f6b55d1ee19c69dbb91b84145db43116ec02c865ce42759d2a99"
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
