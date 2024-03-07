class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/9d/59/ea3c8b102f9c72e5d276a169f7f343432213441c39a6eac7a8f444c66681/csvtomd-0.3.0.tar.gz"
  sha256 "a1fbf1db86d4b7b62a75dc259807719b2301ed01db5d1d7d9bb49c4a8858778b"
  license "MIT"
  revision 3

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d721fd1a97ce3f4e2d58732be3119698608262d32debf0e2aad2bd3d3b29007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff4aa190bde016364d7d523df05e7f1b7df89f42f7dd66bfccd15a4c961636d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13318d241885d3d741cb37b257df45dd22c73e7be2ad9f7978542c5c60a971a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "22a184e87fa2357a17e81e791b4351facd87d21dbf3f09fafb32ff14a4ec0e54"
    sha256 cellar: :any_skip_relocation, ventura:        "956c70957312c6ee6125f976575d1af5959f5bb2cab7c7d1a1c3e7a29cbc5a8b"
    sha256 cellar: :any_skip_relocation, monterey:       "468989125a2f71ac62fad09c13f5ef54a390a462dc7d122885bf7dd71b27d150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1662efe1ed0d02a00afc4fee58a8bf4d1935b66b54c97c22d1778e874b9b29a4"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

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
