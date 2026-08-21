class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "e7e49a09c664a76afc5bc25ca09871eb090bfbe68a2ddbc72750d3cb215d36f1"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b8a518a74f9d270c61c7e892c5e837d1ce997bdf67b7f60c0b6d9572e4c009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50c12d3a07d15ef99b30627d32d4b57dc1aca7bd566a58647abe7ef43b0afba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7992bbfdf364fd63af72f443628ff06e4d33d2594f338fc23a94dc6eebbcd3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7317032afdd51cee5f9da0a4578e71a138c26c80271e9a44a53e7e01cb5c0a13"
    sha256 cellar: :any,                 arm64_linux:   "5cc7b73553b6a49eb9a7073cc51d54eb97ac20eeae2bc7462505c79aa024cde2"
    sha256 cellar: :any,                 x86_64_linux:  "6c01022b87c51d17090647349980ea61a0cb0543affdb3d8ecdd1e26af2214d4"
  end

  depends_on "rust" => :build

  def install
    ENV["ASCIINEMA_GEN_DIR"] = "."

    system "cargo", "install", *std_cargo_args

    man1.install Dir["man/**/*.1"]

    bash_completion.install "completion/asciinema.bash" => "asciinema"
    fish_completion.install "completion/asciinema.fish"
    zsh_completion.install "completion/_asciinema"
    pwsh_completion.install "completion/_asciinema.ps1" => "asciinema"
    (share/"elvish/lib").install "completion/asciinema.elv"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
