require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.23.0.tgz"
  sha256 "04b0ffb211a7c9182fd9e33c0d16eb6f8621dcb089659a8289da1933b65d00fe"

  bottle do
    sha256 "9c983ed61881b06cf1c8d49438d883574435a5b2f946d3b32a05759f6745b4bf" => :catalina
    sha256 "121ca0f021b82be065429b3d2816a3303c6c1b20c3ca87dffc772aec9fd060a2" => :mojave
    sha256 "0ec89dc98c5dab3f3c5b2c05c52d0fd126cd39209736cfa1bf452a5afe2930b3" => :high_sierra
  end

  depends_on "node"

  # fixes node 13 compatibility
  patch :DATA

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end

__END__
diff --git a/npm-shrinkwrap.json b/npm-shrinkwrap.json
index 2101ae4..9d4d743 100644
--- a/npm-shrinkwrap.json
+++ b/npm-shrinkwrap.json
@@ -5034,9 +5034,9 @@
       }
     },
     "ext2fs": {
-      "version": "1.0.29",
-      "resolved": "https://registry.npmjs.org/ext2fs/-/ext2fs-1.0.29.tgz",
-      "integrity": "sha512-AoHwqSNx8SLZizLCMs+etrvdethI+jzak5yVmHACV+G0ziiLd19E3OQpC+SMmGOL1V+uRz3om7VxT5itfThYfQ==",
+      "version": "1.0.31",
+      "resolved": "https://registry.npmjs.org/ext2fs/-/ext2fs-1.0.31.tgz",
+      "integrity": "sha512-bfaggH7juFJNxXoY2nPShr8CSFbijKRsPYOwmSSms88I5n1X7+qsVqnMLLiq6VMI9MxHIFvqGfB+cwum0U1uPQ==",
       "requires": {
         "async": "^2.6.1",
         "bindings": "^1.3.0",
