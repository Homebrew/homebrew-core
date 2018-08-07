class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.11.0.tar.gz"
  sha256 "cc26485dcc9777f9c1770f91afb252f77ed96ef5af67c6a152caa9dc7f0bfafe"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0aa789ac1be455ff321fcb57f06d969edafb90c511bc180952206e421eec910" => :high_sierra
    sha256 "e79cb8d50cddd4a523b2ad3d93e8bdb4ee4df2271ebfc234f69431173a069a14" => :sierra
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
