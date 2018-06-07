class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.10.1.tar.gz"
  sha256 "974c389cdadd38117df39207ccbf9256f0cab240969caf6c15d95787237ca309"

  bottle do
    cellar :any_skip_relocation
    sha256 "616ebc62f15f77ae7a355ade39762fa9758baa12ffe8ea23492a0856982b3268" => :high_sierra
    sha256 "6b9778e827eb82af595acb4e8ec2e0fc85bf7ed0d3821ae0be97920c31d7674a" => :sierra
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
