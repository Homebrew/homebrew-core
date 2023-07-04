class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "30e9e1eb02f49d2862a7fd9ba94c85ea201427a3286dd0421851baa2dc5af773"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfe4f187b493b6020d9e2b5ec9d730a472dc25f41edcd82c39a5054fd6fbc9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc3f2e96621ae58abb1ae5de9237db3e30f4827d43d6dc6f574e6da4ba88df10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e52717501ebf5284e3b7432123af7abe3170d55fb371af84cedaa73cfe712b2d"
    sha256 cellar: :any_skip_relocation, ventura:        "a40755c6def4458f02d397923a719e6b3593f61b38bd4e315dd544a498e5977e"
    sha256 cellar: :any_skip_relocation, monterey:       "03a8ad52dece5f314ece5780bb5fc6da23ff0d5db20e7d42d26fda581aac5252"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f3ced0cb21448695be16ee2592ee8c3b2753c27ea1e240938efa8f0f8fdf8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fccc854838168d825c788d724ef2191950a1e38c7056f838abb88eeaa704bad0"
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
