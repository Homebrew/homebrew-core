class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "871256a171520d5949d651a3a03509b684676110fb6fd581ea7cfc32c5321557"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "870901bc0e97e17b2cd3940f9724a2a755a3b5952ab578d747a035bc5b22b3c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "956d11ded7f6227f75dc1b300ffca5f1d424169446ab072b4f90985bb1f7c462"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0779f9f9ad2a39e8d2b5be0593f7d66efb96604f14e02e179a274c26cfccf43"
    sha256 cellar: :any_skip_relocation, ventura:        "2424cb017bd0ca18328e509ab087df0bfd4610ed907e9a84fc87f7da91449b60"
    sha256 cellar: :any_skip_relocation, monterey:       "bef77c018910c0df34d16b6a867328c7541caaa8b9354566c0884a316ea0d49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "628f040a39af3c80e23f3b6b9257080580c327329ea13d73c619a1cfa5b7ba1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c379dc4e23bd6de48f2cd3fabfa834b6131fb0e3a84ea53a387874290c832b18"
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
