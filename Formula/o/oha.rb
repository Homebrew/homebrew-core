class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "a78cbb27b4cc5f343595f93bf09e344c05fc9eea02dae8ce593cb37592b9bcb3"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfecf2295cf4dd210866d4ddd740b11d26e2c968497b98353dc10d10b2364d5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c1d7d16dae9b827fafc985dd02cf330aeb4635609fbcb19181a496dfae6ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f0237cd57820e7608e6847f62b063a29238ce182e3c7e1bd8ee95c2004a4530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad19bad4b3d31d5ca55615e222e374c95b4311de76ed96dd25c6e10f03cdcad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccaf0fcaa20021b1cdd1c7a361b63d0655dbd6475a0d40f24bea39c73348c40a"
    sha256 cellar: :any_skip_relocation, ventura:       "236a1b5006cdcf05f4963cb4ae49205b8db5fafde1ad9c2bb944b6c141cedf49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb74c522c2afe3165e53f313983c2d461d75f4ebfd2ba60e921c8964d9fda5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f6dca8c7506804b450826be9609afebf379f78c0275afe4c52cdc2853bdc15"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
