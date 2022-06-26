class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b853af50c6361838a90b50bdedd374571fcc09e7f3fdec436c233f0a316b0327"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d2f7791540a8be090435ce7f07933898cb83215ad2d52ede0e9f72b0b220648"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c3bf58234949160e5103642305e285265d499153723f0b0d84c216b20e0bba"
    sha256 cellar: :any_skip_relocation, monterey:       "e6660b414447b893fe02abd9e8cbb6857a12bfaf91945b1a461e098fe137d2e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e0fdc1dbe490f913c7f82ab80f2f2ee6e9eec4d75bfe2306d36714da2f6135e"
    sha256 cellar: :any_skip_relocation, catalina:       "60b65765e244d411eb15f37ba4395dbd5e039523fafc1263af728a22211cc326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e68c0006a3612198dccfd0e3cd8c4d6e0d8ca967c214ac014debf734c04498"
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
    assert_includes output, "Site does not exist"
  end
end
