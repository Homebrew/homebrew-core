class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.17.4/gopass-1.17.4.tar.gz"
  sha256 "de75d2a43cd7ae54cdeac2e3074456ab2a79901c607a24166804878269415989"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76abfb7fdc776f717f0e9fbfc3142b6e9183a1cf5281103d401d0ca0dbae6db1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4df5d604faf395ca1be8901057a6d657539c17528de0001317e51c7667d22274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99755f485c6b99cb33c1ce7e4a308920f24e1d50205eccdafa28c77958254084"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c6b68a6a9fd063af14a5208c8e4e06a66a58e814046f51ed3aeaa3c8207b5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ac3410f09ae56f052847cbd144d77a70674b253a5128b2478a06dd89e6ce562"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    args = ["PREFIX=#{prefix}/"]
    # Build without -buildmode=pie to avoid patchelf.rb corrupting binary
    args << "BUILDFLAGS=$(BUILDFLAGS_NOPIE)" if OS.linux?

    system "make", "install", *args

    bash_completion.install "bash.completion" => "gopass"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG
    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
