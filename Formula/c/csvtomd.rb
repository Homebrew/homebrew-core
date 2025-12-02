class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, all: "5ec7258739ce76c3ca9987d824d27efcd6897ba1f75e72fe59dc975f5e4b1246"
  end

  deprecate! date: "2025-01-10", because: :repo_archived

  depends_on "python@3.14"

  # ValueError: invalid mode: 'rU'
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~CSV
      column 1,column 2
      hello,world
    CSV
    markdown = <<~MARKDOWN.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    MARKDOWN
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
