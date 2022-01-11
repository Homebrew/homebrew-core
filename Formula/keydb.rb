class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/EQ-Alpha/KeyDB/archive/v6.2.1.tar.gz"
  sha256 "9376b5e14f317840cfd05fee06467e6ad7612e32da98bcb8991f5674d61d550b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3edc5f6fff1387faccc130742a7e9f6b63362587e735eb847ed028022a12e951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17eac0584f9f378ef65a36a6b99a573f0c9c47278c2bd90702e9c5613b20d906"
    sha256 cellar: :any_skip_relocation, monterey:       "d11afa68b82e1377f2d35ae5b3b2d4d32d23556530e5cf696d1146ca5b7b1cd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc79925e9e1269a7f9299fb63b594c04fd93e700b17b3c4d947e9e4e31315ce7"
    sha256 cellar: :any_skip_relocation, catalina:       "0e2e47bc09b13d17c672bc3002ab41838723d310c5bfa23a277f51d63d2df925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02b4344bff06c19347219de736dd85953c18d14d5205e2d44b4bceff77393a3"
  end

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  # Fix build on macOS (https://github.com/EQ-Alpha/KeyDB/issues/384)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/EQ-Alpha/KeyDB/commit/7a32ec39fdb738e9c3cd2b73ee18355ced793a65.patch?full_index=1"
    sha256 "06d29f24ff08032f3c211f1c322ba50f64dda9d40fbbe914ce16d8553fd68870"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
