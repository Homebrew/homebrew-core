class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "9f71d17f1655357ec939d1b10429595fc31ef36f481eb78851ad33422cf50eaf"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d932b6748ed6bfdb45c4053bec6e812b6a9e9f9fed0e4dbf99197a602764124a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89bd5e0bdd0e18a4d657754f8bb1c1f4a984b4b0a1e011cbac8d495153fc86bd"
    sha256 cellar: :any_skip_relocation, monterey:       "182b3fc18b006d63e8bf56b3fe9725c0106599f37faecb99aa2a18c9afb11f09"
    sha256 cellar: :any_skip_relocation, big_sur:        "999dd6644969c8a2a3e5c477367254a6b07bdcfa4da184ca687bfc465d426a8c"
    sha256 cellar: :any_skip_relocation, catalina:       "f643fee97a84f401a0dcb76f259c2e2e49506cdcec5c0e21470595a323726e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd82f8b70f186c65aa6da4a5a5600fe6b6d73adb13766ffcfac342f3e444a92"
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
