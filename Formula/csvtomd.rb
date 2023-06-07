class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340344c8ac5bd1dedb8d922b8c491bb80a6e2b6c9575676b56b7909344acef44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "340344c8ac5bd1dedb8d922b8c491bb80a6e2b6c9575676b56b7909344acef44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "340344c8ac5bd1dedb8d922b8c491bb80a6e2b6c9575676b56b7909344acef44"
    sha256 cellar: :any_skip_relocation, ventura:        "0644156a7787998b6056d120df749095ffbd3d20e330e72074ad75bc90412f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "0644156a7787998b6056d120df749095ffbd3d20e330e72074ad75bc90412f4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0644156a7787998b6056d120df749095ffbd3d20e330e72074ad75bc90412f4a"
    sha256 cellar: :any_skip_relocation, catalina:       "0644156a7787998b6056d120df749095ffbd3d20e330e72074ad75bc90412f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c324ebdfa22e9e83a7c6603910e86b2787afca3cda9df5284ea98976ac7e95"
  end

  depends_on "python@3.11"

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
