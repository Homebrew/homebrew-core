class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.6.tar.gz"
  sha256 "b08f4953c6f77a80882dd9b13735ca4a63f14ada1b51d619f17e58a6fa085262"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18b6d423dff719f2c56939eca2416d8a6235f1493e92529932f637a4286427fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "f456bf2580fe0f30448d0f4ab938b74e98de4e95c5d29790cf0f2e6c92e7546b"
    sha256 cellar: :any_skip_relocation, catalina:      "7afb84c24489da1c79b34b6429e71911a11c36237359001a1ca27ab8fe33ddde"
    sha256 cellar: :any_skip_relocation, mojave:        "269bcc403430b25471b8401cc7aa416caf0a35b33350e4ab747dd57e32782136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a4842538f644a9c9b5de585217cb9ffa64ff299637d3f18d3ea942d9e82068"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
