class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "79174e0e19cac2b1a2b9cc226d9f7ad8a9a1bef079b79a3d9bf2bd29cb1ca87e"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b261a6877543112b01257e11e9e7410a41b790c85ff092bcf84b57869e67ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6a58acc9ee1c9b1245ed9e743e850da78da1d24f44aeb3e0793f840f7279af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac0d5ea3387e4e94b9956164a9ab153830a171ee390aca086840436cced4f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c5734606bc7249305739acc8df35243c04ab2895ca0e72fcd291dca0f3a959a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae7fac972298740f999c59c83bc8a1734cc22de20812a06eab7f18b48263443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a158de443b148bd43cf8c2cc85c37e12dc7ff8f81d4317abe4182d9de62ca7ab"
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
