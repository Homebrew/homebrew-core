class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.19.0/source.tar.gz"
  sha256 "02fc084a925824f9b8ad899803da4c895341a6ae2fcb585ca8eac4fbe1fb454e"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eb11c5b9f67dc155ed426a101029a9445c9c088beb520d8b0b8c3b64accf0f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258558bbe65a9c54906ad2487778d369c531dd6d400873944202f7188a1d08b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b387fae485e925a8fa7065bb90a35349f51ae6fd28d3954d20d987c2e659dbad"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eeb97001326a0cd635aec5e8db823b283ed8fd2e367ba523d0f4474d763ff17"
    sha256 cellar: :any,                 arm64_linux:   "e5bc75d6b42fc2adae0d7fc04672e03485e41f864f0b36e84a866163b0c448e7"
    sha256 cellar: :any,                 x86_64_linux:  "52891ba9303cfd0159cf625a9600f1e4162de620459a60b452b2b9c1b78cb553"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
