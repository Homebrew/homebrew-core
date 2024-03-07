class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfab4319e3f6f785023a0a926a5064b77b2615f69029593b87822f6e1de91def"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7af8a248dac87d1ca3833f58124f2f4996d22b82672045a878ddbd457d12c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3604137f92ff09c4cbc0e842d7ab9a58b6c0dcf3a9a04d3515a0eb8e38a1ca86"
    sha256 cellar: :any_skip_relocation, sonoma:         "293373ab4c4380b9f2f80a1520437a2475a31739b9adb5106e70f86d2d261e84"
    sha256 cellar: :any_skip_relocation, ventura:        "d4dfd7ae585a3c68088e8ddaa236e204a0a9d160296761b4baffa3ea3289caf3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5f98e998b63fc42aed8346cc01b838b387fa4ab3378cf39799874ee8036549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6be70b468bfabdc49bc77695a7153538adffc71a0fef7fd7ede02c2f252ab1"
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
