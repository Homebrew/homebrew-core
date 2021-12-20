class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "f9b987f7104efc40b2c2e64fdeb65c4c027cdffdedcf15b2d07d811bc8385717"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8356f4c5473fde60da41c1c887a95b35aa0a2420fa5f09764c28fb64aebb8c4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a52d113a4c4cd9b64ba81aed51168b8b6dfd5b661615d57f3d63ff245eaa70d"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0bafe7213cdfa2fbffe028e669e440fa5d6cffc3d7d487d6e5ffe907bf3c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63a5235f88b9a2d156c4284fd5e67940e2d247607f85b88c19bcec5cf9c4406"
    sha256 cellar: :any_skip_relocation, catalina:       "8926b870031909ade2e1cc2c265e84ee2330e4c001d37e938e9bc0b34a288873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4997fc993ae1a453905d0dccbbe9e15d28ecf657538d5790149d978820bc28"
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
