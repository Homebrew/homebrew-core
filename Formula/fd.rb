class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v4.0.0.tar.gz"
  sha256 "e564a11ad1beb8979b45d11ee592ed9a633fabf445eec0c766d87857b46bb636"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "26783ca7907c72f893fa988ec5b78d21c270a4a11b309e16357cbe21299e9b3a" => :high_sierra
    sha256 "fb3731f970bc97458c723700f8f7da1f47b259ef96ae85e2160256c463391742" => :sierra
    sha256 "94827a4f6413385ae1fe88bb9858c8fefaf050d161b95e37f765578784582133" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
