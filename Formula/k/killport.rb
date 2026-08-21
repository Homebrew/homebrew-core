class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "01c30e5a213582daf829332aa8bf96f41404f6871e58d85f5a5af53f454d8127"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807f206c9b4afbc6ff9330ec419784cc4ba5d650ef44972f8231febb1e952327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f29375dd1edb5e503d0bc301c04420771d98045206ec95c875dcc7270474fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe2333cf794807d6b75d8f08bf0e7f9dc6e7145a45ed12d37a23567cc38f420"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cfc9dde00d56793d4a70e268117a6845a8c8433a147d5d5800c207b1d9b4031"
    sha256 cellar: :any,                 arm64_linux:   "8741318089474d3c29d3caffea827c5e17c21c4fc4750238daec4805a6e5acc6"
    sha256 cellar: :any,                 x86_64_linux:  "e64559d2c9dca3621b670c9856a56ab632a5507a6aef9784962d133a0faaf09b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/killport-*/out"].first
    man1.install "#{out_dir}/man/killport.1"
    bash_completion.install "#{out_dir}/completions/killport.bash" => "killport"
    zsh_completion.install "#{out_dir}/completions/_killport"
    fish_completion.install "#{out_dir}/completions/killport.fish"
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport #{port}", 2)
    assert_match "No service found using port #{port}", output
  end
end
