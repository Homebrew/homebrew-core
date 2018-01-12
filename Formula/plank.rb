class Plank < Formula
  plank_version = "v1.2"
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank.git", :tag => plank_version
  head "https://github.com/pinterest/plank.git"

  depends_on :xcode => ["9.0", :build]
  depends_on "kylef/formulae/swiftenv" => [:build]

  def install
    system "unset CC; make archive"
    bin.install ".build/release/plank"
  end

  test do
    system "#{bin}/plank", "--help"
  end
end
