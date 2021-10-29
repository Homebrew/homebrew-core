class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/FirefoxPWA"
  url "https://github.com/filips123/FirefoxPWA/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b5759fef28405d82a4cc1ac6b1d15c638436738e5ce7d6d5754c781a0b88140f"
  license "MPL-2.0"
  head "https://github.com/filips123/FirefoxPWA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8011ea3753cec00291e6b8e8e651ab725a46422f8ffc1cf5ba215b5b71a41b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5660760defc4bc0ad71a3f8a1b5a8ee51df8c2a5ac900cd277b40fd7d33db8dc"
    sha256 cellar: :any_skip_relocation, monterey:       "a631ea41c03152bebd5c3e6ff9c75a59205f86cd4b0d9f4c8c35418208255a74"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a1229488363bdc0539d53bc44e8f75838468fdeddb8f1ec4eb09c5dd6f306e0"
    sha256 cellar: :any_skip_relocation, catalina:       "39e52a68849054c02f65e1d647f33417ce851d1d7e764da4648df7c53df2eccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e192a694e897df7297d11fec06d8cadf01060b5eb591b08df03032816c0924"
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
