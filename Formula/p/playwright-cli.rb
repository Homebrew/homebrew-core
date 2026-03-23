class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.1.tgz"
  sha256 "8dc10eca24accbe5cab280d8949c771888aedaf8aca6a3748f218be98df240df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98424477ed3412f638fff0ad9d016183ad1dd298e5fc67924b0b6ef6ec765c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42482884343e0c2905936a2d6116e3de131378e2d73c225fdd3af974b056dc29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42482884343e0c2905936a2d6116e3de131378e2d73c225fdd3af974b056dc29"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f38242613fe7187bed5aa571e9aff3dfe605236b26382fca12a90085d1b7dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a06a3bf08b82d485c20577e84f68e603942668aeda6a360474b38c29dadf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a06a3bf08b82d485c20577e84f68e603942668aeda6a360474b38c29dadf86"
  end

  depends_on "node"

  # Backport upstream install-browser fix from https://github.com/microsoft/playwright/pull/39280.
  patch :DATA

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@playwright/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end

__END__
diff --git a/playwright-cli.js b/playwright-cli.js
index 65f7a28..e40c780 100755
--- a/playwright-cli.js
+++ b/playwright-cli.js
@@ -16,4 +16,17 @@
  * limitations under the License.
  */
 
-require('playwright/lib/cli/client/program');
+const args = process.argv.slice(2);
+
+if (args[0] === '--version' || args[0] === '-V') {
+  process.stdout.write(`${require('./package.json').version}\n`);
+  process.exit(0);
+}
+
+if (args[0] === 'install-browser') {
+  const { program } = require('playwright-core/lib/cli/program');
+  const argv = process.argv.map(arg => arg === 'install-browser' ? 'install' : arg);
+  program.parse(argv);
+} else {
+  require('playwright/lib/cli/client/program');
+}
