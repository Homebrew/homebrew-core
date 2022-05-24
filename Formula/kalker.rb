class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v1.1.0.tar.gz"
  sha256 "4332563b18e1c2c8c54871e46f40e55791d3f86612d4651c69b690827051a484"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe51555a7082dbc0c29516e6ffaff1e60ca388cca40de922bd4c80bf0f7aa308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "004d659c074463d3585884c6faaf4dc51fb1e54756cd1ee20b901a5e4bff31c5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9623aff88732ce09f49647a8a7b24ba2b85a597612a6248990523f5316f737"
    sha256 cellar: :any_skip_relocation, big_sur:        "f421b47e1a23b2f13d746ddb2e3cec3e5740ad7bc2f209ceda65561c941430c1"
    sha256 cellar: :any_skip_relocation, catalina:       "2bcfe91cb1bf9cd5965d5236dbd9d284aa28e4a4c71770f12a193653207d4816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864346ef0aa887f58b5c0d0d5fb28670e39505fbf303e25ce5043bf07581c122"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(1, 3, 2n+1)'").chomp, "15"
  end
end
