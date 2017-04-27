class Dj < Formula
  desc "dj, the Django CLI"
  homepage "https://github.com/aleontiev/dj"
  url "https://github.com/aleontiev/dj/releases/download/v0.0.3/dj-0.0.3.tar.gz"
  sha256 "bc8849498c5abf9cad9b47c31af445da64f6a618b8888f04c1f13314d674aa26"

  def install
    libexec.install Dir["dj.exe/{.[^\.]*,*}"]
    bin.install_symlink libexec/"dj.exe"
    mv bin/"dj.exe", bin/"dj"
  end

  test do
    system bin/"dj", "--help"
  end
end
