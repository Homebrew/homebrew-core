class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eed766a6f29e3d703e25841c984b9e5ade0e1e85f36235c9c0f09c534ce4047"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c194f33451da325338b2d9aacf026e44ae669a8108b7038fd7c9329f00c7abe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588b808f4bceecef4e1963e5307988020ad69363655e8b7aae1d3006c7da73a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f3d56988c0a0e2fc2b85cb6dc8496c654d88f420936255051d04dd99d1e7e49"
    sha256 cellar: :any_skip_relocation, ventura:        "e37455f23f5e84e25e95ea7449ff1d505d2f52e2512709aa6cefb3939cd1d09e"
    sha256 cellar: :any_skip_relocation, monterey:       "93dceff9f564d6c949ad1c4141989c340ab71eb7c24c82a3df9d1dfdd0235c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd3157ec526caa2fd5007afc8e8c448e92be76cd0f0ac0f58d6340b23e75b5b"
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
