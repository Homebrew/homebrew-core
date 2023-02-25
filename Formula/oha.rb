class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "966c2c634fe8e4c30bec4be38a9bb1effcda06ef8496c94678c7e4192981f934"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb963c69bf0793dfb89353fbf3ccf10fcc0bae93740990608e2ba56fa7949001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "246036afe03fe6a20a46d714ace96933de05e358c973df9a401e3566a76fd6ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8537e699c9ad4370fab674fd1726152bbc361c52df2d9b40e1e4deacd40ab0d"
    sha256 cellar: :any_skip_relocation, ventura:        "154ad8d56cf453d7d17d1d398da3e32b9e5c8c8a6accb23ce5ca52b07469659a"
    sha256 cellar: :any_skip_relocation, monterey:       "f147cc326d58f07b32698ae684792bf6176fe58514883d6a95fc1204046f2079"
    sha256 cellar: :any_skip_relocation, big_sur:        "511f37af1297639b1708ccac8c2b7940930d6c5496002d1f3ad662ec9d344a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030e56fa7414418b86e8c706a169c9fd0fcc2157380e1bf6673419878fa108dc"
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
