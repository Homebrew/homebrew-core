class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a65b30224e02e9348177308ad6bcebf37d388ed88fe5cc3d49765435850caa2d"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa3db1bf04bd9d07c6da957a52d3158f68f2b9722a81903eb3b23081935223ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19632b03de564a06bc304e9a2111a319ceeeb87ffbf0b1bf7bbcf7d5873a6097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e23318c6f8f0bbae55e305364610adbcaa721c8fcb95749d3c590d2f67fd383a"
    sha256 cellar: :any_skip_relocation, sonoma:         "33edfd30f9afffbd66d6bdaf301a698cf86ab0cda3d8d7c24ca76bd9e15c5c4e"
    sha256 cellar: :any_skip_relocation, ventura:        "b9cdffb59fc1d5b4cd2049bccc07dab3c2f7fa4753bae5afcfcc1e0a416c50eb"
    sha256 cellar: :any_skip_relocation, monterey:       "47fd165b02bb3f12552bb2e21d9fac3b549afc76c8ee5d02eda199251cd9a4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e213662caa738d4cac919d2286682a860cf92331ec97a65077d433fbb22aa58"
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
