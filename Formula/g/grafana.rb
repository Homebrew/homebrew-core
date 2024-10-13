class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  # TODO: switch to use go1.23 when 11.3.0 is released
  url "https://github.com/grafana/grafana/archive/refs/tags/v11.2.2.tar.gz"
  sha256 "223dc284b8fa03641154aaee3b35f77515b04b3b076a0db887e0b0498b1be7d9"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5d68d06cdae814f820812f5548ea0e670f29220e02c5275f1f280ba8468858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd2f901e29f8d0ea3ac63387cacfe45e9dd2b42f1a5141c9fc7342d0af5d8d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e7cd38573d0907e9ead33ddc9e1168878bcf42f849c54c9dec0b51c70fd050"
    sha256 cellar: :any_skip_relocation, sonoma:        "715ddcfece7f6fa0c0b48dbdc8c3a137c02f90eb425f9f1748acd5cbee8864c9"
    sha256 cellar: :any_skip_relocation, ventura:       "463ddee5aea38b03fc3cd0f9f710e91f54226381e8e74113f2387d32f615804b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456d9d4546fe10ada6b0047a589053957f00f4acf2e67e85dfbe378c606d1de0"
  end

  depends_on "corepack" => :build
  depends_on "go@1.22" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  # update yarn.lock, upstream pr ref, https://github.com/grafana/grafana/pull/92543
  patch :DATA

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "bin/#{os}-#{arch}/grafana"
    bin.install "bin/#{os}-#{arch}/grafana-cli"
    bin.install "bin/#{os}-#{arch}/grafana-server"

    (etc/"grafana").mkpath
    cp "conf/sample.ini", "conf/grafana.ini.example"
    etc.install "conf/sample.ini" => "grafana/grafana.ini"
    etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"
  end

  def post_install
    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  service do
    run [opt_bin/"grafana", "server",
         "--config", etc/"grafana/grafana.ini",
         "--homepath", opt_pkgshare,
         "--packaging=brew",
         "cfg:default.paths.logs=#{var}/log/grafana",
         "cfg:default.paths.data=#{var}/lib/grafana",
         "cfg:default.paths.plugins=#{var}/lib/grafana/plugins"]
    keep_alive true
    error_log_path var/"log/grafana-stderr.log"
    log_path var/"log/grafana-stdout.log"
    working_dir var/"lib/grafana"
  end

  test do
    require "pty"
    require "timeout"

    # first test
    system bin/"grafana", "server", "-v"

    # avoid stepping on anything that may be present in this directory
    tdir = File.join(Dir.pwd, "grafana-test")
    Dir.mkdir(tdir)
    logdir = File.join(tdir, "log")
    datadir = File.join(tdir, "data")
    plugdir = File.join(tdir, "plugins")
    [logdir, datadir, plugdir].each do |d|
      Dir.mkdir(d)
    end
    Dir.chdir(pkgshare)

    res = PTY.spawn(bin/"grafana", "server",
      "cfg:default.paths.logs=#{logdir}",
      "cfg:default.paths.data=#{datadir}",
      "cfg:default.paths.plugins=#{plugdir}",
      "cfg:default.server.http_port=50100")
    r = res[0]
    w = res[1]
    pid = res[2]

    listening = Timeout.timeout(10) do
      li = false
      r.each do |l|
        if l.include?("HTTP Server Listen")
          li = true
          break
        end
      end
      li
    end

    Process.kill("TERM", pid)
    w.close
    r.close
    listening
  end
end

__END__
diff --git a/package.json b/package.json
index 062d5dfe..43c0f838 100644
--- a/package.json
+++ b/package.json
@@ -414,6 +414,7 @@
     "semver@7.3.4": "7.5.4",
     "debug@npm:^0.7.2": "2.6.9",
     "debug@npm:^0.7.4": "2.6.9",
+    "@grafana/e2e-selectors": "^11.1.0",
     "slate-dev-environment@^0.2.2": "patch:slate-dev-environment@npm:0.2.5#.yarn/patches/slate-dev-environment-npm-0.2.5-9aeb7da7b5.patch",
     "react-split-pane@0.1.92": "patch:react-split-pane@npm:0.1.92#.yarn/patches/react-split-pane-npm-0.1.92-93dbf51dff.patch",
     "history@4.10.1": "patch:history@npm%3A4.10.1#./.yarn/patches/history-npm-4.10.1-ee217563ae.patch",
diff --git a/yarn.lock b/yarn.lock
index 6aed8dda..5318138c 100644
--- a/yarn.lock
+++ b/yarn.lock
@@ -3233,7 +3233,7 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafana/e2e-selectors@npm:11.2.2, @grafana/e2e-selectors@workspace:*, @grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors":
+"@grafana/e2e-selectors@npm:^11.1.0, @grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors":
   version: 0.0.0-use.local
   resolution: "@grafana/e2e-selectors@workspace:packages/grafana-e2e-selectors"
   dependencies:
@@ -3251,17 +3251,6 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafana/e2e-selectors@npm:^11.0.0":
-  version: 11.1.0
-  resolution: "@grafana/e2e-selectors@npm:11.1.0"
-  dependencies:
-    "@grafana/tsconfig": "npm:^1.3.0-rc1"
-    tslib: "npm:2.6.3"
-    typescript: "npm:5.4.5"
-  checksum: 10/010a32e8b562d0da83b008646b9928a96a79957096eed713aa67b227d8ad6055d22cc0ec26f87fd9839cfb28344d0012f49c3c823defc6e91f4ab05ed7d8c465
-  languageName: node
-  linkType: hard
-
 "@grafana/eslint-config@npm:7.0.0":
   version: 7.0.0
   resolution: "@grafana/eslint-config@npm:7.0.0"
