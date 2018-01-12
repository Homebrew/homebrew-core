class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.2.tar.gz"
  sha256 "9ee8c248d7b4488f7f952b01d913b34cd83bd40111092fd49015d1c63b9e885d"
  head "https://github.com/pinterest/plank.git"

  depends_on :xcode => ["9.0", :build]

  def install
    system "make", "archive"
    bin.install ".build/release/plank"
  end

  test do
    system "#{bin}/plank", "--help"
  end
end
