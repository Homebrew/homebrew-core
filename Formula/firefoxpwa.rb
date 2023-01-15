class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "75f288505dcbca9a6dece3221ccea3e77fa6c6792e20c6cda4f829bc025a16ef"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "841744949be4519b5aed3cb45dc95c2143ae4e10b4142e62871880781806bf33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c44df3190c2ade1901fe3fdbcde02cef20c97bc4a4e783f3fdb76346fa8ba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1a078be7e769e1bc91f62798412d998c3064017c3e181ab427a164dfab90b8"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd6a60d73d792cd46b20c72b22b6481d088a517cfa4a2a6eb39f44b4cfa3b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "8aa832650a1bf76fd6a1fb374ee1635ab1a4585513ecfa79f4ced7a53aaec9c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f660812d69174bd75312d9702617deea2214e66b7fe401850c77045f75d0eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ac098bd881dc420017eb74d5e8347b507ee39b990260308ca3cf787b638ca8"
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
