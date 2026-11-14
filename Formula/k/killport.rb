class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "01c30e5a213582daf829332aa8bf96f41404f6871e58d85f5a5af53f454d8127"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "142091cbd4e78d882a92e60b344ed972f076b3611ff467d6446ca437f44554d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30dbe52794f770ef89a8f8433defca5f5e84129e204586472f391aa810df1d28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435effe94181bc0bd64f1e05ca9183746f8d43db84582c16d64f7e02469fbcdd"
    sha256 cellar: :any,                 arm64_linux:       "5e17868192b3e2e182c1e61e82995d72d7021809ce22aef1449d08eefd150309"
    sha256 cellar: :any,                 x86_64_linux:      "92b07fdb159ad9278951005942d877e25e4708547b32500dc8e4c7a495da74be"
  end

  depends_on "rust" => :build

  # `test do` block binds a local port.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Pathname.glob("target/release/**/killport.1").first.dirname.parent
    man1.install "#{out_dir}/man/killport.1"
    bash_completion.install "#{out_dir}/completions/killport.bash" => "killport"
    zsh_completion.install "#{out_dir}/completions/_killport"
    fish_completion.install "#{out_dir}/completions/killport.fish"
  end

  test do
    port = free_port
    shell_output("#{bin}/killport #{port}", 2)
  end
end
