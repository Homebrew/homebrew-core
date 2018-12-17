class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.11.3.tar.gz"
  sha256 "e1e41455df18c99b17c4f7ac5f1ab5e0c11a186573eeb49cbff0c2584f514aca"

  bottle do
    cellar :any_skip_relocation
    sha256 "c935b2d5135c8402b4ca3683bfa80a95a9025cc8ab13be9aeceb0c0dd8958eba" => :mojave
    sha256 "076d4da11065a2ba39e5542e7109d1d84cbba03ff5f3bc964ead150a17afc0a3" => :high_sierra
    sha256 "3309359ee8f8b00c8c57b3361a840fc5a2917d9d212dc7bdf3f34c7327decd82" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "--help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
