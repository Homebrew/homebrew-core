class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f97832d69b4e486997b9548c41f6cc945c68b8a8b546172ca92b7eb23ec71be5"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "265468ffeb9eb54a17b7168d232b812866e5c1aff8f5156c7201dbecab51e330"
    sha256 cellar: :any,                 arm64_big_sur:  "a9b4016475921abd16bcb8cab0271f66939b96ba87bccd487557fb73b367df34"
    sha256 cellar: :any,                 monterey:       "5b9b9ff8ddc7cf4cbc524eabff9563d032fa0107f3982f2238429e3c9a029771"
    sha256 cellar: :any,                 big_sur:        "0c92df442716cbadf5c95b6ab7286c0298f411d17c6de57c4a5043c0d85a551d"
    sha256 cellar: :any,                 catalina:       "cc79194372d1d12ccdfec0d6a973efaf40f9b47e4834781ae40c45d423fb2d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33d3fd101678f3cc8e3a0a3d1c11f50c27067702f300f767fda1e16e3dac451"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
