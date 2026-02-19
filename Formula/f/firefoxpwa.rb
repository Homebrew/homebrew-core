class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "befe6568ae09d266a0ef1f6f526f0e903f84e04ce9606bc2bc57a75f97bce208"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "744c68f9ec2fa9273159c711dee849c7256c16ceaf180b60735becbaa97371d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88db2dfcf74daa35a4c653d78620f3a41280bcdb1257e7b1ae2951d5736ccc6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5be9864b2d68e763cc59a5940cec83a0651f8962837cc0c2747c2ff7124bf0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdfd35e1a646506a0dce7c326a8d15a602b682b1fceefce9472a0431e22fe66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5473e3582fcedc5542f14c16a8a1c76cfe1ad602147ea003c921a4a4f303f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba3a14e84e2c1823745c8bba97e8d4ba28d444d61bc438010b1bff23df30a9a1"
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
