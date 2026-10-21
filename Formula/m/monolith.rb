class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "19390d1032cd2e10a7a589228fd035ab60b07f093a46e8a2bce4fa1c08f5e66b"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0819ad1e672c482fe9ef81de79f2d1ad9f1f9973e62ea747cd9d3fb9704294a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3768fd17b26e95d71cc3961d5da0971ef8e2125f4579ab2e38fd1c60ae70ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "194326564fc5b4152a0b87954011e5ac73aac156ac642b3809b3058d351ca495"
    sha256 cellar: :any,                 arm64_linux:       "3932df1c9d4d5824c36526f41b55879a865ba07ddd29ac26b4d748a81a9d77b9"
    sha256 cellar: :any,                 x86_64_linux:      "e0801235acaa8fcaa49e95dc7c37f1cca36e96ca5d67fc539ac8c62a087f7286"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
