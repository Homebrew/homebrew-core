class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/v1.0.1.tar.gz"
  sha256 "b014a44b27f921c12505ba4d8dba15487ca2b442764da645cd6d0fd607ef068c"

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
