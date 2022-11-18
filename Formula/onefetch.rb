class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.13.2.tar.gz"
  sha256 "6a57e12fb049af89de13aeaf06f206be602e73872458ff4cd5725d3b82289123"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d87dfe9824d0ac95198779f4a07e95754331bd77e9b5bec84ccc23c1061d4c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f9c93230cb9892c4bcb843cd65ae4d20e648784bacc708dd3ce92bb1dc6f45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6594a0aafd7c636f0a6c50228d95477b077df6460d3d54c36462d7555e6c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "ed52509ec3096d4f1c4733de9ddc177797f03f11d2e8c78945763f9e67302ab7"
    sha256 cellar: :any_skip_relocation, monterey:       "f92797185a5368cbf1960a7da83eaa2b1d45332b21bece8c6b88045bc5e16a53"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a0006e7cc0bec2ddfcda64e14e053c9b4132623e14709c0cb00983af40069f"
    sha256 cellar: :any_skip_relocation, catalina:       "632c7903cdec94d15b55b9cee78485df87539882319a4a323334a7e4b352f72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fddebe37d3ff783ee0a8c66a28d87563d682fe119f1e16631b21d7b46391f511"
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
