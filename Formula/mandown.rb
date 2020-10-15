class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/v1.0.1.tar.gz"
  sha256 "b014a44b27f921c12505ba4d8dba15487ca2b442764da645cd6d0fd607ef068c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "09ad2e54a3b54c9687580b4499f4c5247dfd2e18fb64230b3c255fbc7df1c5be" => :catalina
    sha256 "9186b868866dd17f080343297e145161f3fe6303701a12bd0a47f8ef246f6630" => :mojave
    sha256 "acf617ed0300f38b429ed05504c47bb9e403441316d335ae83bf28c18baa63a6" => :high_sierra
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.md").write <<~EOS
      #Hi from readme file!
    EOS
    expected_output = <<~EOS
      <title >test.md(7)</title>
      <h1>Hi from readme file!</h1>
    EOS
    system "#{bin}/mdn", "-f", "test.md", "-o", "test"
    assert_equal expected_output, File.read("test")
  end
end
