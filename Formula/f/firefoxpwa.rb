class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "16a0d92fab9167059dbbdd14213e2a92285deb3c2c4917a29f7a7d1709aee973"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b2eee93ac9dc3a7cd7e06fcfdc6973449273e982e4c0922dc06a339ce131b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de903f0e3e2db9c07cad851343bc936d797f9a97830b9e9643929670f1211853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a776a30af2df812957fcee7ca9c247f6641595152b025ac544167ab8d32f44"
    sha256 cellar: :any_skip_relocation, sonoma:         "486b48c337c56be57675a60e4939e3645f2aa7ab9e783f07025c57571b10f073"
    sha256 cellar: :any_skip_relocation, ventura:        "a62b331fd5a1e39e2fdd1ba14e62840dc4644682a8db5f62b1c346ca7f7005d8"
    sha256 cellar: :any_skip_relocation, monterey:       "54a908d6b236af89de3038fb0e40806f5a2d3d3cfa5c25ce43200aab107f6c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361b1ef4254e1159271015a6e50bfd868d528844c87ea376c62dcf8c096bfe69"
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
