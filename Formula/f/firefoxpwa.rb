class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "781b4eeb3bed69f75860a23f5b61a14c6dc4eee4505b184344a124b93f4bf308"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b2035fcaa454720d8f519d9c993e24b49ab83eaa74026e67431fa1d05fde88e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32e16ca97e07b15dd8fb116833d2151b1b3c067bb5723e8346ec2d3b2755a9e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d003a3b567a32eeecad1e511fd61a7da2a91af53b0855dea70ae87aa56fe39d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1325064d6dcebbc6261444fbe607b30daf7cfc324692b15f22d8efac0f2374a"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd9d3900aae538bf4a85674ad9db5368e713b41f8ea703a5db03a6eda7e5456"
    sha256 cellar: :any_skip_relocation, monterey:       "85aa53a7678293eed779384e59b1b9e17df630aac8946c88f1d1f8d1a16fe194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a24f86e965f6ad85f015b2e3f610346b9a8e3ed824d0a99063cd90890b6ed7"
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
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

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
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
