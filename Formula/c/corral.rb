class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  stable do
    url "https://github.com/ponylang/corral/archive/refs/tags/0.9.2.tar.gz"
    sha256 "c6b0000fe2f5c451923988e2fc44da3f2a3c37dd35f2125239028edebdb408b5"

    # Backports to fix build with newer ponyc.
    # https://github.com/ponylang/corral/commit/10b85e36e5c7ec4503ecb80ff51aa2342e459805
    # https://github.com/ponylang/corral/commit/ca5490e878c4f636739482b8d20e4dacd13e6b93
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "874284f3436e96093485b55a5b93542690a4bbe95e84bb39b62d1b11705b03c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f3de1320410cb39bc11d33df5cad6e582d890625cd335e86cb7989d0a386f68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a562e1fe2715cef547ce09cf263d19b07b8bb20264a90b1a49782eed5e8ff4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d4273e435e4df08d17fb7607379c1d978e76d8af4e7e83c57abe3a99d328abc5"
    sha256 cellar: :any_skip_relocation, sonoma:            "3e715fac5e78e7b91e8e5f7ad998aac7133a8ab8197b2f6cd4f40cf547b89d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e91957a9613d01dcf70d745a9ee58142e325573b9ac051351796e669efa1b0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10b3afde7155d1a4ce99cd9e25442fd8cfa52052cc1abfc24469e99fd1f077e2"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end

__END__
diff --git a/corral/semver/version/compare_versions.pony b/corral/semver/version/compare_versions.pony
index 8bbebe1d..6e810afd 100644
--- a/corral/semver/version/compare_versions.pony
+++ b/corral/semver/version/compare_versions.pony
@@ -34,6 +34,4 @@ primitive CompareVersions
     | (let s1: String, let u2: U64) => Greater
     | (let u1: U64, let u2: U64) => u1.compare(u2)
     | (let s1: String, let s2: String) => s1.compare(s2)
-    else
-      Equal // should never get here but compiler complains without it
     end
diff --git a/corral/util/action.pony b/corral/util/action.pony
index 9029248..8351b1b 100644
--- a/corral/util/action.pony
+++ b/corral/util/action.pony
@@ -148,11 +148,12 @@ class val ActionResult
 
 primitive Runner
   """
-  Run an Action using ProcessMonitor, and pass the resulting ActionResult to a
+  Run an Action using StartProcess, and pass the resulting ActionResult to a
   given lambda.
   """
   fun run(action: Action, result: {(ActionResult)} iso) =>
-    let c = _Collector(consume result)
+    let sink = _ResultSink(consume result)
+    let c = _Collector(sink)
     let argv: Array[String] iso = recover argv.create(action.args.size()+1) end
     let appname =
       ifdef windows then
@@ -166,7 +167,7 @@ primitive Runner
       end
     argv.push(appname)
     argv.append(action.args)
-    let pm = ProcessMonitor(
+    match \exhaustive\ StartProcess(
       action.prog.process_auth,
       action.prog.backpressure_auth,
       consume c,
@@ -174,19 +175,34 @@ primitive Runner
       consume argv,
       action.vars,
       try action.cwd as FilePath end)
-    pm.done_writing()
+    | let pm: ProcessMonitor =>
+      pm.done_writing()
+    | let err: ProcessError =>
+      sink.deliver(ActionResult.fail(err.string()))
+    end
+
+actor \nodoc\ _ResultSink
+  var _result: ({(ActionResult)} ref | None)
+
+  new create(result: {(ActionResult)} iso) =>
+    _result = consume result
+
+  be deliver(ar: ActionResult) =>
+    match _result = None
+    | let r: {(ActionResult)} ref => r(ar)
+    end
 
 class _Collector is ProcessNotify
   """
-  Collect Action output and exit into an ActionResult and hand it to the given
-  lambda when ready.
+  Collect Action output and exit into an ActionResult and deliver it via
+  _ResultSink.
   """
   let _stdout: String iso = recover String end
   let _stderr: String iso = recover String end
-  let _result: {(ActionResult)} iso
+  let _sink: _ResultSink tag
 
-  new iso create(result: {(ActionResult)} iso) =>
-    _result = consume result
+  new iso create(sink: _ResultSink tag) =>
+    _sink = sink
 
   fun ref created(process: ProcessMonitor ref) =>
     None
@@ -204,13 +220,13 @@ class _Collector is ProcessNotify
         stdout' = recover val _stdout.clone() end,
         stderr' = recover val _stderr.clone() end
     )
-    _result(cr)
+    _sink.deliver(cr)
 
   fun ref dispose(process: ProcessMonitor ref, child_exit_status: ProcessExitStatus) =>
     let cr = ActionResult.ok(child_exit_status,
       recover val _stdout.clone() end,
       recover val _stderr.clone() end)
-    _result(cr)
+    _sink.deliver(cr)
 
 //https://www.gnu.org/software/libc/manual/html_node/Working-Directory.html
 //use @chdir[I32](filename: Pointer[U8] tag)
