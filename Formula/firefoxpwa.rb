class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "7300aa5849ba884679778541e6b28b1983db03e666f83beea7c538fe91c6dce9"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bef883d33c8bc7a67cd0ffd7c34609779c3dd7c5ad58ef6b543d8d69f2194626"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8cbcab0a43937b439558fd1700d916a2a70e0ca3c1eaefdfe4ba302fd9495c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60a87c9c7ebe052bc62961173230e67994244437b0c63c686f7c79ac1381b970"
    sha256 cellar: :any_skip_relocation, ventura:        "74df570163d7da72a4adba5dcbb600030e5febcade84f196d8bf8e8fc6db0123"
    sha256 cellar: :any_skip_relocation, monterey:       "ac05a9034b4984457c9a90c9b11f0ed11adab4548d70f754c3df8de18549b1b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "24898297100d24d5df426e8fea521e9dc313576df62c5b02b26339b1731776d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c9c80303deba9a450f1d17c1c241a0dc281465a6d401192234ba34011ebed2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
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
