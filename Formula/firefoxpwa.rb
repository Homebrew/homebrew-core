class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "1bc056396893e8bb6859ba5d7560c44c6107e561601ffd31b2fae5b19d65956e"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3fef7068e968e497e69301e5ff01846d9fa9ee65ce7a5b6852cde836a8bbfad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1634cb9ed6d1fd6784feb7db1f5ded86d60e846725733729e556e91650ce7989"
    sha256 cellar: :any_skip_relocation, monterey:       "a0ddbb862eeda606bc88ec1f06f95dc2d4bdb9efcc0cd1a7840695eb7c4b48b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "04804c058d14d823f17b67a3a9855df395953183b8459ecf6e70be38e8818b67"
    sha256 cellar: :any_skip_relocation, catalina:       "d9be7815614d2cfa274c0146cff828407d4212a689064b167af747e61261266c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ab021f7ae7c98d426cb88eb449b5e96b9cd70f6f3917ddca649c38891553b8"
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
