class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.17.0/source.tar.gz"
  sha256 "38f78bffd059fb1ce92d9387af2084ba724a4447865c864b89f39df19024fa8d"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3462bc2b139468cbd55558b73eca438740e6bc132a53bfcf636b9c7b6eace3e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057fff8309c6091bae822538677b90e630b3762ad95757b5f9c0692e0a8a7ce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d40ca1f0b23386104a97b781ddded1acd906f97df1ae9b6c18a9f4ed7f44ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "532d3de2edce2dbd6ef434c457f365808b34c38d02debe978dcc27e435b5e3aa"
    sha256 cellar: :any,                 arm64_linux:   "ecc484f6d342f51a74e57bab6c3e8562d663507a798217d90c152c16c691d211"
    sha256 cellar: :any,                 x86_64_linux:  "7bd1e34725eee5248c1f31dba66307ae6051d1ccf7646fb4c357c2f7a9608fba"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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
