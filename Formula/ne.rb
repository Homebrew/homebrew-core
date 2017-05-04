class Ne < Formula
  desc "The nice editor"
  homepage "http://ne.di.unimi.it"
  url "http://ne.di.unimi.it/ne-3.1.0.tar.gz"
  sha256 "bf2a664e788e4f39073d0000a4ba80f02c43c556cb7fd714704f13175a4b8b51"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cb47aff1c91d22fd98578df10d6c17c1afaa6e493085e453954e540d0dacfa0" => :sierra
    sha256 "b9f8988279a64a070cbadd618d3561b4ef8ed3b4fe3f474b4ea5a1dcbb0f3d2a" => :el_capitan
    sha256 "b5c3a4e39341af06d04d2d233cea0ae56f81d2f1f52ece6ecb9982651794f225" => :yosemite
  end

  def install
    cd "src" do
      system "make"
    end
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<-EOS.undent
      This is a test document.
    EOS
    macros.write <<-EOS.undent
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<-EOS.undent, document.read
      This is a test document.
      line 2
    EOS
  end
end
