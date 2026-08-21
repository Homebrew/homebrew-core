class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "4755ca8828169199c5d9023905660f9f11e3d224f1d8f2d467cb738e4ba03536"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ed1dab37b5830016b723d0a169facdf28d13ed43c746bf14570f8e54d95fbe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3d8501f8617a4ffe18036799c0e774413ef2a6f24d2c4892fa5e6af8f72b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b0bd7bb0c81b286c1ad4bb11db3909ee22c9539c35639247ead176196f97442"
    sha256 cellar: :any_skip_relocation, sonoma:        "5256bfebaa5ffbbc331b4281e0efd9f1f4d08023779a2449e571c6c6214697af"
    sha256 cellar: :any,                 arm64_linux:   "128b0b576b3ecfa732c277cc5753dd1afa98c07912903a4910a5a540b6de80e7"
    sha256 cellar: :any,                 x86_64_linux:  "aa914b3488472d3bfe60cfba2accc4421a39fe50a91b07f8fb729fcdf6cb40d7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
