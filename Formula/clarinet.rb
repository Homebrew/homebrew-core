class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.15.0.tar.gz"
  sha256 "af7fb4913c219449088214749af02109d2ac5d40ea39da50a8bba42d2cde7f5b"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27d4a6740525955d6ae284e5a31c767121576d1465fa2b3163ce397cf3380433"
    sha256 cellar: :any_skip_relocation, big_sur:       "f370e6bd23ccd8a6525ab94814536510d6db99503a718e7677f0c46c8d9bb9e2"
    sha256 cellar: :any_skip_relocation, catalina:      "b249798ce2310d1bbbc2ca6b0260ef0e46b0f06ad32e80c3aec67b1021232de0"
    sha256 cellar: :any_skip_relocation, mojave:        "26f6b854d18eda7155f802d982ca16d465b16ed594b6d50283c039e9e83b9743"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
