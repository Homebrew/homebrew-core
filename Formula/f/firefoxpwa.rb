class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "597bb57eb7041829940bf6d6592f7d312d76386c246b29e3f1a000fea255d6cf"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "604a474022bb1b6aec25a17b2b8d73c2a3c81793ae655339a11b7c4d4755d74a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b63f58763451149a49b3bda63258dd7fe8c20ff12360de87e5084ab815ac3ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d9b8013f9aa037ecb7b158409ba383ea3289661a572be01a1fb8792f8d3575c"
    sha256 cellar: :any_skip_relocation, sonoma:        "01df9ba07b5a9cd63077dccb93298979d26f8d44434830aff5a9524bd77d0881"
    sha256 cellar: :any,                 arm64_linux:   "c94a2cef843c0db91990348603a68cea036575178ffd91710f46fd4a26b2db9c"
    sha256 cellar: :any,                 x86_64_linux:  "1e69963282e7265a98327adc5b403e051790c2327314d6f674c7722270d7e985"
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
