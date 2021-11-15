class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.6.1",
      revision: "0eaf1848f412d555f57ed9724325e934ec4838e7"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "637f8bfe6712471e08eab2a2ae7936380e60be053d845494903079dd1db611e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1818dbfa03b46c14fd6319ddc58181d6bf8219b1e6984af4b1776966b3b5344b"
    sha256 cellar: :any_skip_relocation, monterey:       "b5f6e6ffbd485b54336caf6b33a4ed8e70f805391347e9ac4a71f579aa44fad1"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e6ed1a8fb1b808067cf600c40a6c417287769710a3b1052cd155a4bf2aa91f"
    sha256 cellar: :any_skip_relocation, catalina:       "b19d21c40470c2244484cd7bb1e59b0fa67046d2e8af2bdf02e97880896cdea7"
    sha256 cellar: :any_skip_relocation, mojave:         "26af1dc72d59fda49a071aa3c61fb8376bb7a13a56ac6a674709ac210dba90ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "507116948e5c775cc1459f15c599419e6d9c65ab5fdecf00d5b4c9f80a0edf6c"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.7.tar.gz"
    sha256 "9bfe2c06b09fe7f3274f4ff8da1d87c9102640285bb38dad9a8c26dd5b9fe5af"
  end

  # Temporary resource using version specified in the go.mod of kapacitor.
  # We currently need this to support building with Rust v1.54+.
  # Upstream issue ref: https://github.com/influxdata/kapacitor/issues/2612
  # TODO: Remove when `flux` version in go.mod is updated to v0.124 or later.
  resource "flux" do
    url "https://github.com/influxdata/flux/archive/4347b978c91a46349790f773239589ba6abdfd98.tar.gz"
    sha256 "557cf85a756a633dacb08852ee55889c246df412330119bd844612d2cc55ce23"
    version "0.116.1-0.20210519190248-4347b978c91a"

    # Fix build with Rust v1.54+.
    # Backport of https://github.com/influxdata/flux/commit/c29d2c02ab42d591bb91e5d6321dacba3609e928
    patch :DATA
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    # Fix build with Rust v1.54+. Remove when flux in go.mod is updated to v0.124+.
    r = resource("flux")
    (buildpath/"flux").install r
    system "go", "mod", "edit", "-replace", "github.com/influxdata/flux@v#{r.version}=#{buildpath}/flux"

    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"kapacitord", "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf" => "kapacitor.conf"
  end

  def post_install
    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  plist_options manual: "kapacitord -config #{HOMEBREW_PREFIX}/etc/kapacitor.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/kapacitord</string>
            <string>-config</string>
            <string>#{HOMEBREW_PREFIX}/etc/kapacitor.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kapacitor.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kapacitor.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    begin
      pid = fork do
        exec "#{bin}/kapacitord -config #{testpath}/config.toml"
      end
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/libflux/flux-core/src/parser/mod.rs b/libflux/flux-core/src/parser/mod.rs
index c35771a6..6430654c 100644
--- a/libflux/flux-core/src/parser/mod.rs
+++ b/libflux/flux-core/src/parser/mod.rs
@@ -32,7 +32,6 @@ pub fn parse_string(name: &str, s: &str) -> File {
 }
 
 struct TokenError {
-    pub message: String,
     pub token: Token,
 }
 
@@ -1398,7 +1397,7 @@ impl Parser {
                                 value,
                             }));
                         }
-                        Err(message) => return Err(TokenError { token: t, message }),
+                        Err(_) => return Err(TokenError { token: t }),
                     }
                 }
                 TokenType::StringExpr => {
@@ -1473,10 +1472,7 @@ impl Parser {
                 base: self.base_node_from_token(&t),
                 value,
             }),
-            Err(_) => Err(TokenError {
-                token: t,
-                message: String::from("failed to parse float literal"),
-            }),
+            Err(_) => Err(TokenError { token: t }),
         }
     }
     fn parse_string_literal(&mut self) -> StringLit {
@@ -1520,7 +1516,7 @@ impl Parser {
                 base: self.base_node_from_token(&t),
                 value,
             }),
-            Err(message) => Err(TokenError { token: t, message }),
+            Err(_message) => Err(TokenError { token: t }),
         }
     }
     fn parse_duration_literal(&mut self) -> Result<DurationLit, TokenError> {
@@ -1532,7 +1528,7 @@ impl Parser {
                 base: self.base_node_from_token(&t),
                 values,
             }),
-            Err(message) => Err(TokenError { token: t, message }),
+            Err(_message) => Err(TokenError { token: t }),
         }
     }
     fn parse_pipe_literal(&mut self) -> PipeLit {
diff --git a/libflux/go/libflux/buildinfo.gen.go b/libflux/go/libflux/buildinfo.gen.go
index 104cb0c9..d1223a3a 100644
--- a/libflux/go/libflux/buildinfo.gen.go
+++ b/libflux/go/libflux/buildinfo.gen.go
@@ -29,7 +29,7 @@ var sourceHashes = map[string]string{
 	"libflux/flux-core/src/formatter/mod.rs":                                        "de2216b303b3a57627bae6eb7788e7b7ecc5ef5638242380533e9efdea7e512e",
 	"libflux/flux-core/src/formatter/tests.rs":                                      "e6bd0be3341673a6c2b5d45ebefcdf6f74c7608eea7f45410aff43c66f1916b8",
 	"libflux/flux-core/src/lib.rs":                                                  "49b07452edaed71ccfdb850c3ae1b7d8903f4e4837ae601d300edab19b34004c",
-	"libflux/flux-core/src/parser/mod.rs":                                           "31b69ead574a94a5652b25be1d134bd48a4b342603c6a6f72f46726520ca5b3c",
+	"libflux/flux-core/src/parser/mod.rs":                                           "221cc327e434573ca27b46864ea3b53f151f1491dfca2dcd7af06b27ac0bda10",
 	"libflux/flux-core/src/parser/strconv.rs":                                       "748c82f6efc2eafaafb872db5b4185ce29aafa8f03ba02c4b84f4a9614e832d2",
 	"libflux/flux-core/src/parser/tests.rs":                                         "e3a7c9222f90323a7ea9b319bd84f96f66c6f115af6d199a0da332c894713ae4",
 	"libflux/flux-core/src/scanner/mod.rs":                                          "2e15c9e0a73d0936d2eaeec030b636786db6dbe7aab673045de3a3e815c49f8a",
