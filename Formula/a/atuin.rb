class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.16.1/source.tar.gz"
  sha256 "aec5c91207f080becc4b13593d5b7edc46685e8d4dbfbaef33d31f8058191bc6"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14cd72cc8ffcafc20213c20486479b9455a4e176fa8cc0ae36c5dec40a297d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0336c5c298e3dc794d08046e405800927efa98ed0ec6db1fe021903f8aa1600e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60cab2e648e37d530c199fdb7fa2a7032fad86b934834c723b1c716dad8f9f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "18b3d0c66b7f0df5c1d466c8f62934559339eb02a77d0e05561021a881713673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8a1b86f1861e5c5ec887c29d90830edaca3a71efb56c646f8da653aa3a8435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365ba50aa0394edaf890e2b773a545dfa5b77e93991943fc1fa203d347f0a8c0"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
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
