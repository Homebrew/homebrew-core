class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48579239f7f8987fe06dbf7b7c47a4b964d1533d148059c1600807a13b837712"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0d95d751793f6de924d7bd9dd454846725c8402bbdcf43e6039f99ff8a42ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2523b00bedd64f44624d1294e1e0d68d21cf8f22811fb5403ea69c0c5ba72039"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd2866f71ebb4f2f53351e55813fb68acd6daa645a27f9d7f1878debca3f877d"
    sha256 cellar: :any_skip_relocation, ventura:        "2528c9d814edac0b28ae00f049e88d14d74608cd7d7ba71f5cb4e5d27251a5ea"
    sha256 cellar: :any_skip_relocation, monterey:       "42eaac28f122adcc820e3cb1c0997e41243db298593757a6d0cf65a615e2a60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48c2757350d82e6e636381410d9c9273c28340c5e5f83b78f3bc1106114fb5a"
  end

  depends_on "python@3.12"

  # ValueError: invalid mode: 'rU'
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end

__END__
diff --git a/csvtomd/csvtomd.py b/csvtomd/csvtomd.py
index a0589a3..137f8da 100755
--- a/csvtomd/csvtomd.py
+++ b/csvtomd/csvtomd.py
@@ -146,7 +146,7 @@ def main():
         if filename == '-':
             table = csv_to_table(sys.stdin, args.delimiter)
         else:
-            with open(filename, 'rU') as f:
+            with open(filename, 'r') as f:
                 table = csv_to_table(f, args.delimiter)
         # Print filename for each table if --no-filenames wasn't passed and
         # more than one CSV was provided
