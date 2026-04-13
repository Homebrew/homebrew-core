class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "06e01de691c0fd0244cef340ac6bd0fb991d779191b0f5014f97353691a508e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe2f63551697527506e0fe8f97b7c21b28e0eec96dd6b923611a3c292105f3ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4084ec7d357dbfb28eba4577097d03c402af83cebaf37d45b4728f3d2f15a7fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518d331177158c7f98b6f3614bebfdae1ec7222d90351b30c97e4d949995b09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b014c0628cebc3706b16476b2d268d75be4502aba623bd80802ea9efc0db0c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ebaa7fef654c5cb054a995279e9dd2f2178985e75efdd2f482e442902fd6ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76db18b18f55cb5500a8681356308de355fa008e196013aba8837f2eeaf987a7"
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
