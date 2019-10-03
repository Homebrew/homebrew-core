class Ne < Formula
  desc "The nice editor"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.2.1.tar.gz"
  sha256 "6b9324d9a4c3deef02f4ecf75407f5b5ed4e68a3bb4af3f9c1ea19dc628f9b5d"
  head "https://github.com/vigna/ne.git"

  bottle do
    sha256 "cb22f87c5d36b2071dbf02a62ef29e43776ecd3717ab1583e0f4543d8eaa6a69" => :mojave
    sha256 "a1037e0ec9e8bcfdc3182dcbf328472f73b341c52d4a67d287ae544b254b3b72" => :high_sierra
    sha256 "0b7140758a418d16e65e16f580a531adc72749932975953c081405a0187c8713" => :sierra
  end

  depends_on "texinfo" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
