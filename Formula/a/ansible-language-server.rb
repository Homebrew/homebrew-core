class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/vscode-ansible"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-26.4.3.tgz"
  sha256 "e06a9d0026807c86a692d80921e0dae1166f826db2529d385ed6162b129c889e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "55e9dfc3173ac49bd6499e5186f4483a79f448141bf3933a5248a6a3169b76c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f77d8d03dd3d1c02a29ba66785d2628274f5478363f8fce75a41ca3e6febcc32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea600142aba89658a7896fa5c65ce40a2648b61f8535d569c552416ba38cd5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4575717c98b81f527b192d6687372445551f11c94b1f47058698e1b6cede67e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9a066966f1c8a6abd1ce7e7a453a7199bdf34f17d3fb2c333113764d0cad84"
    sha256 cellar: :any_skip_relocation, sonoma:         "b926dc5d1e4e44a5718cf6d462c3902d8001208d4e3f28f94ed71adbfc44748a"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac3f6ccdfc8b366ae1b0097b1c031e45371e8898b6f8ce988a065f8ee8e33e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a90c681ae308eedcd2f57d363519b9d3eacb123e8772fc6f105b3ac7948f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "69f366a23f834e990444cec8ccb7f0b7a17aa539cf8d54ba78523ba2dc13e400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f51eb058ef24cd16f4f06e1a62b37aa801fa305a9be5ab816553250c07a9a07"
  end

  depends_on "node"

  # fixes `Dynamic require of "util" is not supported`
  # see https://github.com/ansible/vscode-ansible/pull/2755
  patch :DATA

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    PTY.spawn(bin/"ansible-language-server", "--stdio") do |stdout, stdin, _pid|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end

__END__
diff --git a/package.json b/package.json
index 0e1b067663039ecef19804f3792fdf0f58fc0a04..4ed8287c9aaeb4a0b43c66e900944e3d445683a9 100644
--- a/package.json
+++ b/package.json
@@ -3,7 +3,7 @@
     "onLanguage:ansible"
   ],
   "all": true,
-  "bin": "dist/cli.js",
+  "bin": "dist/cli.cjs",
   "categories": [
     "Programming Languages"
   ],
