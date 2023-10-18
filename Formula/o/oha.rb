class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "e9d588e03be7e8b877d610bc22e8bb2b1100ad7de22b1743b9f3cd67953464c3"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34b4683ecf81851211dcfe3119a1f18cd32d2a9babf3ccf82ef96ef4b6ad6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8df8149dd75372bfd5c22518ffc5846d68dc237c77c45c028e46f6929d0327d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736e25103404e1112d223354e6c2f581a4c45679b729a1bab9ae0904377507b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d45a16fd8a9c046e7af06890593f02d604d7933c4a91634c1eb9c95442d8370d"
    sha256 cellar: :any_skip_relocation, ventura:        "ce53e172337e5dfe63bdfc5db277cefb85805d4e0022b857f6e55c43e456040b"
    sha256 cellar: :any_skip_relocation, monterey:       "39b6f1c6e4f8266d6245083302837e07b4e9c8f466b55ff68b10586242ea5e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a8a6cd5e219d026fd6380a59e3f275bc6b421e714ab9fd2431e46591a85388"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
