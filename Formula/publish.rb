class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.5.0.tar.gz"
  sha256 "b149a21ac21640d914e31dc0e0f4c2e24b547e2f4f268921cdc21b0a7dec0538"
  head "https://github.com/JohnSundell/Publish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f943bb9b468c49e2a5e87171d5ee3c11c339a25c74d241915fa8071e794e756c" => :catalina
    sha256 "30e3520375527044e155ee740e4408b466ab2cac2fbfbbc76fa6a9970041d787" => :mojave
  end

  depends_on :xcode => ["11.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system "#{bin}/publish", "new"
      assert_predicate testpath/"test"/"Package.swift", :exist?
    end
  end
end
