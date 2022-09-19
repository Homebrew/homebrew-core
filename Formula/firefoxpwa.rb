class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "357b662b3a7b046789a747275f3e99dc3edce01177615ff455e58cc737d2e6fa"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0561bed7c3cb448db0880628d82a25487dd11522f854f44469554c15322165"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bc6815839da88ddeb7ef569ae07d8607df1061b040a8936e2e337a3c1a7cacf"
    sha256 cellar: :any_skip_relocation, monterey:       "05513f30e3ec5f1470fe6f87d054b83d49803900152ac1191fa3f5b84ca3ef75"
    sha256 cellar: :any_skip_relocation, big_sur:        "211203659aa2e01036e7b36aa6ad1bd8ef7ecd88f1d73c1cfd5aa06e202c59c4"
    sha256 cellar: :any_skip_relocation, catalina:       "721e52279dd985c44175d4a8ea5593196d2b837e4e89b87def1fb063b3dfd741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c6aebc25c177370f39bbb6ebd527c504cd369a8a9483ec7870b7462da870f4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    # Test version so we know if Homebrew configure script correctly sets it
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
