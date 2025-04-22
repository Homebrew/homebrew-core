class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "40d2f4987e473a312947829e1ac57b58d2c322250c335aa1e148a75c9c40aa74"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3069c24c729dce340b2f57eba64f7dbb89975f53bd0070dafb13fc6ed50194c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff180b6bb859922f2d540f8ee582c285089d48b9741e9ce8ed6a7dcbe1dbdab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c66e4a62437eccfb98990123b1197d3fee078edcb537d14647f3e66d493b8ace"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9a6835423008504698149c5966221f23cdb85dfdce35e5330e02ded341abbc8"
    sha256 cellar: :any_skip_relocation, ventura:       "a02fdcabaff02eb0cb2f2a6d9c5f8686d30783a9a316f6c3dff89ef38e08396d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bafeac075f600e09f91539b6b4a4aa8609863cf48cc184b4f9bd665150c84968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb80205befaa0b30dccea8760159222340d783d7a785056e8b4ec5caca0d0ce"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
