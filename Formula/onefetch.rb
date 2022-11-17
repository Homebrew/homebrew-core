class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.13.2.tar.gz"
  sha256 "6a57e12fb049af89de13aeaf06f206be602e73872458ff4cd5725d3b82289123"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858e2abb7e597b7fb2788e8b4e2dd92c144789b1278492eb4f518b417d57c436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c41ad94403092586cff22be00105f6c502b43412782747cfb8f9c42f5e2d0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bd8334d386fbac3963888e30c11e5469de2c9472f4f8788c8ec59103d7cb8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "599c88ecf5b13feaca0b1c415ee08f6e4a0bf12e4de45b1fd884aa0bee109f85"
    sha256 cellar: :any_skip_relocation, big_sur:        "87fc36e318a667a02e9ca376100af5fddbb2d6e270d9b49c7eba844678c69a1a"
    sha256 cellar: :any_skip_relocation, catalina:       "853375fbf854fe419c00e552ba0f3187e3bab076c5051951aea8fca50f1b954e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a5269b84189975729da93e23c1f7ba1b69f08d1194100385bb6bd9c967979a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
