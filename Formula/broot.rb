class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.10.2.tar.gz"
  sha256 "05b520b7511d06d152395b8ea9da3f78fe3bdc7fb2e262a338a7176c9511f395"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f199956e05eb8c777ee6f8f5ecd573d0f67e4502724b6a2a24eef632b377b80" => :catalina
    sha256 "e7e084cdb1904deeb0f46710c962fe35496f470c0538ff4582404c1c028de95f" => :mojave
    sha256 "ce7d18614a5cc44c3f85e1717b6cd4d1efbb005f3aedae96ac6d398cd22b4f06" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
