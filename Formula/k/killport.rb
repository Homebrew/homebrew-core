class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a662571935cc9d425bbce8beb7725ff87e215ac0e47371b1b8b8443b63465dee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d42ef556aa0886e9829d5c5bc19bb2ecc88a4c0d9e5ebdefd759d798e85e869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da9b5481b71ae544b3cab546f4b1190becb991e57ca7ee4d484a1f290a8da7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb54c3a184068d201a603c26a1c13428122adc35c120f89dac32a8a4bcebe72"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b087c1a7693c2ffeb8f4c626b5eda8460ada59e3869024f601c55e6e89fd4b"
    sha256 cellar: :any,                 arm64_linux:   "3dfbad03de5d4d8c38086bce5164c11eed6e418e26e77bdbd4b012e997d192be"
    sha256 cellar: :any,                 x86_64_linux:  "cefe219ddc5532548787d550cae3af272802b36b59c8c34d49084bc3b10ba169"
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
