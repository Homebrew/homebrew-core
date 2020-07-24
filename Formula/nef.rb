class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.6.2.tar.gz"
  sha256 "23915dd21e6485829b5ad88b6a5f4ac6b4ea091fc70820d2322bafba09e2217a"

  bottle do
    cellar :any_skip_relocation
    sha256 "db1f3b419794b096f913f805f08b56e0f51cb01cfa20d4a8bfd77cc6ae1f236c" => :catalina
  end

  depends_on :xcode => "11.4"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exist "#{testpath}/nef/library/apis.md", :exist?
  end
end
