class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.8.0.tar.gz"
  sha256 "c6463068b4d07cc2543107e293a27d0356783ce7c5f316b64f18e3ca7014430c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db6bd52c39d320cf723eba6f627a3c589e41b38a9cf96f4f6779df7f7a525520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89d8776e705d1f833d8f008398888946325e3eb220085c0e84a1e38c61675e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346dda79788f5613d42354f1df4638edcda965a02041526190114344716e5d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf14ff9dc574005441ee09f7d223e261f790521806db922b0932e65f50e77ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dd094529e7b783f52059574da65b59d0fb7446d942c3378365eb64e6bed8a17"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc56af50de8cbad4435edcda2bfac978b80f20286087514d5c10da75a4e9bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "606897e211f554c79f6a86749c2c177044cf0ff8b511a0c7614acda65bd4a069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d707e6dd0106e9f3e00415a48b2bfa897176a961a4028885843fefa3802cf5b9"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
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
