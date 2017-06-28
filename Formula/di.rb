class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.44.tar.gz"
  sha256 "963d00cadbf5a115ff31b31b0d6141be751c7b0a209e50990cb78e36d1a50320"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdf922a2d6b32c5c3bb7cacb3efac022eeec7fc2b923904cee17d0c0aded6550" => :sierra
    sha256 "a8449b5fc5e3e28570f2311a3aa9a7a95beff6373b5e207ae64688773cc3e667" => :el_capitan
    sha256 "cb9cd891f6d513bb6f4f064622a36a2a69ea3b945b023ea683411d53c8273233" => :yosemite
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
