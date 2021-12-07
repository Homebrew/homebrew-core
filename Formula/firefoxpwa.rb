class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b34681e84a3f9018955f887a37beceb895d6009bc045a23d2127eab1ea1b7a57"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb219e4f0baa3aa027941bf5ba2301e795a21ef9a63ff550a7eb79bc2b31b32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1509c36881bdd070e076c737e2d58a32a773dfbc1865246b58cb169610d973c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bd38cdf53287f44a31e32106ed64b5201c2d902d98cda198b315cd0de54e9468"
    sha256 cellar: :any_skip_relocation, big_sur:        "f65eb37e8a20e8c5ecb6f700834a7ead3f6324afb4e98165b86b3669d87ccbc4"
    sha256 cellar: :any_skip_relocation, catalina:       "988e593a3add9cbc9c2f451822a515059dbe23e1c5e0522f778f71c1f9f91816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9757ad1cc6a336fe38339fe7448b25f6317f38232cca821ba51fa30fa703d038"
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
