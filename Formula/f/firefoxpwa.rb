class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "8e1b3f8ed46e96cb6b8480657d767a22b6a4059501b07d6e32e8c3caf4537554"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38fdd740e02bf41f60e6fd328d2f83c4a593f410ccb85f5f9545809718d9eb90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1dd89cdb75c9aefe0fa29db6c1ee78a320021fb832c37327354c67bc4ebd039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21de171e7f962cd9d9475a30557da713629ea1649dd4cee79e758340a4d36f0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4750c9f1ee89253749353cfca9f1ac3a6bc499bf92a99d7f02b2f542b1e8ec0"
    sha256 cellar: :any_skip_relocation, ventura:        "6658cb07a136661b3b924c6c319682cb3dcd83890430292236dac90dee534ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "7cfb28d9883e96fa5eb79e6a8dd550fb5b2743e08a703e1ff3b59b693829b186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e57980b4453227af5a5e2ca2ec91e06de3a83a8e3201411b81ff0640220189f"
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
