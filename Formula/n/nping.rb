class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9f3cc2cdd8da55e41390ccd3a506f14ceb08169e1c09b9f0362f4a1bfb70bb36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf392dbb27e3a8ae2e87441cc869047f3d31e5717ad6351ad803b42abacd5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1938bd0556101cb5fd0cc476e0047b15457365c50b95266a63dc22c5fcc094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf27a5da091ae144c5e6176b399b4db72277e1836fa612686e9a642d69d7753"
    sha256 cellar: :any_skip_relocation, sonoma:        "13c67dd0e4e03b092f879dcd9fd61af447f0b731fae1b73dcb98274fc096c385"
    sha256 cellar: :any_skip_relocation, ventura:       "60b4938b512b6d5e6833b557b4ea3883ceb7c901ffd523b0a672d492d8efb419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ff7a20338d9f9b9b0fae0402a3680d8f08f106217ec8dee9ff6d810899a958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad71ecba02888016f5259c21ddef36643aa8a1ddec4b153a3ecafd993f6159c6"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}/nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nping", "--count", "2", "brew.sh"
  end
end
