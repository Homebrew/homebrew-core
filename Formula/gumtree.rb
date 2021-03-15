class Gumtree < Formula
  desc "Tool to deal with source code as trees and compute differences between them"
  homepage "https://github.com/GumTreeDiff/gumtree"
  url "https://github.com/GumTreeDiff/gumtree/releases/download/v2.1.2/gumtree.zip"
  sha256 "a5e9747d9e208fed3522b1dcc4cb4bd293d4d276827afa2c20a2f4ac433c2730"
  license "LGPL-3.0-or-later"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"gumtree").write_env_script libexec/"bin/gumtree", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"foo.rb").write <<~EOS
      def sum
        return 1 + 1
      end
    EOS
    (testpath/"bar.rb").write <<~EOS
      def sum
        1 + 1
      end
    EOS
    output = shell_output("#{bin}/gumtree diff foo.rb bar.rb")
    assert_match "Move CALLNODE: +(5) into NEWLINENODE(6) at 0", output
    assert_match "Delete RETURNNODE(6)", output
  end
end
