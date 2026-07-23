class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "aafb96d059cf9734da915dca4f5940c319d2e6b54e2ffb884332e9f5e820e6d7"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3010007ba0d5879cfc388d3b85da78b20705ded1b6fef52aab5ba40b6d4264a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68844daddd6f6888ac773f51bb44194c6609f27c1da223abca7690bd3e945673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b729baafeac965993e3aa7093d3c1af635fcf94fa3fceee6ad261eb16ed3c105"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ba6a626e25e7dc40eba76784b871db53461c8031b1e6a2426afab9d7de319a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9be322f6125f0cf6deea31fa59fc019a7861b3f80dd5abc297abf4602503d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb5abdfed0d43ec8a0e82b82eb0581f4f760ebbb56a2ac574e9cea5e0128455"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/bandwhich-*/out"].first
    bash_completion.install "#{out_dir}/bandwhich.bash" => "bandwhich"
    fish_completion.install "#{out_dir}/bandwhich.fish"
    zsh_completion.install "#{out_dir}/_bandwhich"
    pwsh_completion.install "#{out_dir}/_bandwhich.ps1"

    man1.install "#{out_dir}/bandwhich.1"
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
