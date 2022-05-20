class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.1.1.tar.gz"
  sha256 "817497a17bf131afb1ea4fa53eaeeca566949360be168b393260a18ea64c0dbb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e6ad129b749562bdb31486c28d05e5aabb006b5ae1aa2a86f7aa6d000a1fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b63a76d8a18f2d5c8946be992dbacfe9d7141f5c4a304e56a62a4f01e6637e8"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5c30da518bb1a35c8777a66cc434756bfca3efd1687b71d5cbc3e902975a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20e2cc8ba3389d035aa0455cc738728ba0f4328864cc47993a76b080a6e7581"
    sha256 cellar: :any_skip_relocation, catalina:       "512d8280ff6087b35c536e55162551099ab535cf9b1e9b21d39c805a9ad8ebbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3936ab295b06dddc9d79c8c18ac5f08894a1c670e69ca205d53762b6df69a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
