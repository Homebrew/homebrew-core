class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "d07aa56100cf11727889d3f999c57d26da85ef6068fc35ad830e000533fd1e47"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazel-watcher.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c12651e6c9cbc680f6e787336fc2f2af53ccdd09cc7fafc8ee27a9317f507df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3244d3623fc940b32da49370e3b4d78edae09fa66fc336a80dc5a2a6bfca08d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a7ca0a10912f7e99064fa84f76e4c05a0d1e1aefc026572187c66064872f37"
    sha256 cellar: :any_skip_relocation, ventura:       "74d628872158223d2254232f97bc08654db611958b4269ed5b60aa91d8c3ec50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f218a79d9f3d14172c346ef78f621bfb3dd03f9e5e0e0b9f0199fbb5f6cc6e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd9fbcb138b56677b3123f7194cb5d13675a5cdd6f8dcfd9a41f218b3b67828"
  end

  depends_on "bazel@7" => [:build, :test]
  depends_on "go" => [:build, :test]

  # update go toolchain and refresh deps, upstream pr ref, https://github.com/bazelbuild/bazel-watcher/pull/746
  patch :DATA

  def install
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Allow using our bazel rather than pre-built from bazelisk
    rm(".bazelversion")

    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    ENV.prepend_path "PATH", Formula["bazel@7"].bin

    # Write MODULE.bazel with Bazel module dependencies
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_go", version = "0.50.1")
      bazel_dep(name = "gazelle", version = "0.40.0")

      # Register the Go SDK extension properly
      go_sdk = use_extension("@rules_go//go:extensions.bzl", "go_sdk")

      # Register the Go SDK installed on the host.
      go_sdk.host()
    STARLARK

    (testpath/"BUILD.bazel").write <<~STARLARK
      load("@rules_go//go:def.bzl", "go_binary")

      go_binary(
          name = "bazel-test",
          srcs = ["test.go"],
      )
    STARLARK

    (testpath/"test.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    GO

    # Explicitly disable repo contents cache
    pid = spawn bin/"ibazel", "build", "//:bazel-test", "--repo_contents_cache="
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a/WORKSPACE b/WORKSPACE
index 9493f4f..db63008 100644
--- a/WORKSPACE
+++ b/WORKSPACE
@@ -25,10 +25,10 @@ http_archive(

 http_archive(
     name = "rules_proto",
-    sha256 = "66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1",
-    strip_prefix = "rules_proto-4.0.0",
+    sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
+    strip_prefix = "rules_proto-5.3.0-21.7",
     urls = [
-        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz",
+        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
     ],
 )

@@ -46,19 +46,19 @@ rules_proto_toolchains()
 # gazelle:repository go_repository name=com_github_bazelbuild_rules_go importpath=github.com/bazelbuild/rules_go
 http_archive(
     name = "io_bazel_rules_go",
-    sha256 = "d6ab6b57e48c09523e93050f13698f708428cfd5e619252e369d377af6597707",
+    sha256 = "80a98277ad1311dacd837f9b16db62887702e9f1d1c4c9f796d0121a46c8e184",
     urls = [
-        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.43.0/rules_go-v0.43.0.zip",
-        "https://github.com/bazelbuild/rules_go/releases/download/v0.43.0/rules_go-v0.43.0.zip",
+        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.46.0/rules_go-v0.46.0.zip",
+        "https://github.com/bazelbuild/rules_go/releases/download/v0.46.0/rules_go-v0.46.0.zip",
     ],
 )

 http_archive(
     name = "bazel_gazelle",
-    sha256 = "501deb3d5695ab658e82f6f6f549ba681ea3ca2a5fb7911154b5aa45596183fa",
+    sha256 = "32938bda16e6700063035479063d9d24c60eda8d79fd4739563f50d331cb3209",
     urls = [
-        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.26.0/bazel-gazelle-v0.26.0.tar.gz",
-        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.26.0/bazel-gazelle-v0.26.0.tar.gz",
+        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.35.0/bazel-gazelle-v0.35.0.tar.gz",
+        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.35.0/bazel-gazelle-v0.35.0.tar.gz",
     ],
 )

@@ -66,9 +66,135 @@ load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_depe

 go_rules_dependencies()

-go_register_toolchains(version = "1.19.4")
+go_register_toolchains(version = "1.24.4")

-load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
+load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")
+
+go_repository(
+    name = "com_github_gogo_protobuf",
+    importpath = "github.com/gogo/protobuf",
+    sum = "h1:Ov1cvc58UF3b5XjBnZv7+opcTcQFZebYjWzi34vdm4Q=",
+    version = "v1.3.2",
+)
+
+go_repository(
+    name = "com_github_golang_mock",
+    importpath = "github.com/golang/mock",
+    sum = "h1:YojYx61/OLFsiv6Rw1Z96LpldJIy31o+UHmwAUMJ6/U=",
+    version = "v1.7.0-rc.1",
+)
+
+go_repository(
+    name = "com_github_gopherjs_gopherjs",
+    importpath = "github.com/gopherjs/gopherjs",
+    sum = "h1:EGx4pi6eqNxGaHF6qqu48+N2wcFQ5qg5FXgOdqsJ5d8=",
+    version = "v0.0.0-20181017120253-0766667cb4d1",
+)
+
+go_repository(
+    name = "com_github_jtolds_gls",
+    importpath = "github.com/jtolds/gls",
+    sum = "h1:xdiiI2gbIgH/gLH7ADydsJ1uDOEzR8yvV7C0MuV77Wo=",
+    version = "v4.20.0+incompatible",
+)
+
+go_repository(
+    name = "com_github_pmezard_go_difflib",
+    importpath = "github.com/pmezard/go-difflib",
+    sum = "h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=",
+    version = "v1.0.0",
+)
+
+go_repository(
+    name = "com_github_smartystreets_assertions",
+    importpath = "github.com/smartystreets/assertions",
+    sum = "h1:42S6lae5dvLc7BrLu/0ugRtcFVjoJNMC/N3yZFZkDFs=",
+    version = "v1.2.0",
+)
+
+go_repository(
+    name = "com_github_smartystreets_goconvey",
+    importpath = "github.com/smartystreets/goconvey",
+    sum = "h1:9RBaZCeXEQ3UselpuwUQHltGVXvdwm6cv1hgR6gDIPg=",
+    version = "v1.7.2",
+)
+
+go_repository(
+    name = "in_gopkg_fsnotify_v1",
+    importpath = "gopkg.in/fsnotify.v1",
+    sum = "h1:xOHLXZwVvI9hhs+cLKq5+I5onOuwQLhQwiu63xxlHs4=",
+    version = "v1.4.7",
+)
+
+go_repository(
+    name = "org_golang_google_genproto",
+    importpath = "google.golang.org/genproto",
+    sum = "h1:387Y+JbxF52bmesc8kq1NyYIp33dnxCw6eiA7JMsTmw=",
+    version = "v0.0.0-20250115164207-1a7da9e5054f",
+)
+
+go_repository(
+    name = "org_golang_google_genproto_googleapis_rpc",
+    importpath = "google.golang.org/genproto/googleapis/rpc",
+    sum = "h1:3UsHvIr4Wc2aW4brOaSCmcxh9ksica6fHEr8P1XhkYw=",
+    version = "v0.0.0-20250106144421-5f5ef82da422",
+)
+
+go_repository(
+    name = "org_golang_google_grpc",
+    importpath = "google.golang.org/grpc",
+    sum = "h1:OgPcDAFKHnH8X3O4WcO4XUc8GRDeKsKReqbQtiCj7N8=",
+    version = "v1.67.3",
+)
+
+go_repository(
+    name = "org_golang_google_grpc_cmd_protoc_gen_go_grpc",
+    importpath = "google.golang.org/grpc/cmd/protoc-gen-go-grpc",
+    sum = "h1:F29+wU6Ee6qgu9TddPgooOdaqsxTMunOoj8KA5yuS5A=",
+    version = "v1.5.1",
+)
+
+go_repository(
+    name = "org_golang_x_crypto",
+    importpath = "golang.org/x/crypto",
+    sum = "h1:VklqNMn3ovrHsnt90PveolxSbWFaJdECFbxSq0Mqo2M=",
+    version = "v0.0.0-20190308221718-c2843e01d9a2",
+)
+
+go_repository(
+    name = "org_golang_x_mod",
+    importpath = "golang.org/x/mod",
+    sum = "h1:Zb7khfcRGKk+kqfxFaP5tZqCnDZMjC5VtUBs87Hr6QM=",
+    version = "v0.23.0",
+)
+
+go_repository(
+    name = "org_golang_x_net",
+    importpath = "golang.org/x/net",
+    sum = "h1:oWX7TPOiFAMXLq8o0ikBYfCJVlRHBcsciT5bXOrH628=",
+    version = "v0.0.0-20190311183353-d8887717615a",
+)
+
+go_repository(
+    name = "org_golang_x_sync",
+    importpath = "golang.org/x/sync",
+    sum = "h1:GGz8+XQP4FvTTrjZPzNKTMFtSXH80RAzG+5ghFPgK9w=",
+    version = "v0.11.0",
+)
+
+go_repository(
+    name = "org_golang_x_text",
+    importpath = "golang.org/x/text",
+    sum = "h1:g61tztE5qeGQ89tm6NTjjM9VPIm088od1l6aSorWRWg=",
+    version = "v0.3.0",
+)
+
+go_repository(
+    name = "org_golang_x_tools",
+    importpath = "golang.org/x/tools",
+    sum = "h1:TFlARGu6Czu1z7q93HTxcP1P+/ZFC/IKythI5RzrnRg=",
+    version = "v0.0.0-20190328211700-ab21143f2384",
+)

 gazelle_dependencies()

diff --git a/go.mod b/go.mod
index 159732d..b544ff4 100644
--- a/go.mod
+++ b/go.mod
@@ -1,7 +1,7 @@
 module github.com/bazelbuild/bazel-watcher

 require (
-	github.com/bazelbuild/rules_go v0.53.0
+	github.com/bazelbuild/rules_go v0.46.0
 	github.com/fsnotify/fsevents v0.1.1
 	github.com/fsnotify/fsnotify v1.9.0
 	github.com/golang/protobuf v1.5.4
@@ -13,10 +13,10 @@ require (
 	gopkg.in/fsnotify.v1 v1.4.7 // indirect
 )

-require golang.org/x/sys v0.32.0
+require golang.org/x/sys v0.33.0

 require google.golang.org/protobuf v1.36.3 // indirect

-go 1.23.0
+go 1.24.4

-toolchain go1.24.2
+godebug winsymlink=0
diff --git a/go.sum b/go.sum
index 5ce6cdb..8fd6fb4 100644
--- a/go.sum
+++ b/go.sum
@@ -1,51 +1,11 @@
-github.com/bazelbuild/rules_go v0.30.0 h1:kX4jVcstqrsRqKPJSn2mq2o+TI21edRzEJSrEOMQtr0=
-github.com/bazelbuild/rules_go v0.30.0/go.mod h1:MC23Dc/wkXEyk3Wpq6lCqz0ZAYOZDw2DR5y3N1q2i7M=
-github.com/bazelbuild/rules_go v0.31.0 h1:8/MDe6zCE7nYKXhlbamM1izUgJjw2ce7M5kd4QKF/3Y=
-github.com/bazelbuild/rules_go v0.31.0/go.mod h1:MC23Dc/wkXEyk3Wpq6lCqz0ZAYOZDw2DR5y3N1q2i7M=
-github.com/bazelbuild/rules_go v0.34.0 h1:cmObMtgIOaEU944SqXtJ9DnlS8IPGGa7pdRnsrpQzXM=
-github.com/bazelbuild/rules_go v0.34.0/go.mod h1:MC23Dc/wkXEyk3Wpq6lCqz0ZAYOZDw2DR5y3N1q2i7M=
-github.com/bazelbuild/rules_go v0.35.0 h1:ViPR65vOrg74JKntAUFY6qZkheBKGB6to7wFd8gCRU4=
-github.com/bazelbuild/rules_go v0.35.0/go.mod h1:ahciH68Viyxtm/gvCQplaAiu8buhf/b+gWswcPjFixI=
-github.com/bazelbuild/rules_go v0.36.0 h1:hKvFRTyZEoHeIjPe/Kd8RL9cP9s3hoeMlO8vywdXSfY=
-github.com/bazelbuild/rules_go v0.36.0/go.mod h1:TMHmtfpvyfsxaqfL9WnahCsXMWDMICTw7XeK9yVb+YU=
-github.com/bazelbuild/rules_go v0.37.0 h1:vbnESGv/t2WgGEbXatwbXAS95dTx93Lv6Uh5QkVF13s=
-github.com/bazelbuild/rules_go v0.37.0/go.mod h1:TMHmtfpvyfsxaqfL9WnahCsXMWDMICTw7XeK9yVb+YU=
-github.com/bazelbuild/rules_go v0.38.0 h1:BY67VX6+Dka4FRQH7CDHmIXYOuPFr1YrrKYsboDC6hw=
-github.com/bazelbuild/rules_go v0.38.0/go.mod h1:TMHmtfpvyfsxaqfL9WnahCsXMWDMICTw7XeK9yVb+YU=
-github.com/bazelbuild/rules_go v0.38.1 h1:YGNsLhWe18Ielebav7cClP3GMwBxBE+xEArLHtmXDx8=
-github.com/bazelbuild/rules_go v0.38.1/go.mod h1:TMHmtfpvyfsxaqfL9WnahCsXMWDMICTw7XeK9yVb+YU=
-github.com/bazelbuild/rules_go v0.39.0 h1:YWJ+hbwEOB/PtIFCRMDnvWVSpwPFFGEpdIB6E3bt8X4=
-github.com/bazelbuild/rules_go v0.39.0/go.mod h1:TMHmtfpvyfsxaqfL9WnahCsXMWDMICTw7XeK9yVb+YU=
-github.com/bazelbuild/rules_go v0.53.0 h1:u160DT+RRb+Xb2aSO4piN8xhs4aZvWz2UDXCq48F4ao=
-github.com/bazelbuild/rules_go v0.53.0/go.mod h1:xB1jfsYHWlnZyPPxzlOSst4q2ZAwS251Mp9Iw6TPuBc=
+github.com/bazelbuild/rules_go v0.55.1 h1:cQYGcunY8myOB+0Ym6PGQRhc/milkRcNv0my3XgxaDU=
+github.com/bazelbuild/rules_go v0.55.1/go.mod h1:T90Gpyq4HDFlsrvtQa2CBdHNJ2P4rAu/uUTmQbanzf0=
 github.com/fsnotify/fsevents v0.1.1 h1:/125uxJvvoSDDBPen6yUZbil8J9ydKZnnl3TWWmvnkw=
 github.com/fsnotify/fsevents v0.1.1/go.mod h1:+d+hS27T6k5J8CRaPLKFgwKYcpS7GwW3Ule9+SC2ZRc=
-github.com/fsnotify/fsnotify v1.5.1 h1:mZcQUHVQUQWoPXXtuf9yuEXKudkV2sx1E06UadKWpgI=
-github.com/fsnotify/fsnotify v1.5.1/go.mod h1:T3375wBYaZdLLcVNkcVbzGHY7f1l/uK5T5Ai1i3InKU=
-github.com/fsnotify/fsnotify v1.5.2 h1:M+aHumjFDOySyAjWICQHrDfuizRTP7nzkRHxXfyRP68=
-github.com/fsnotify/fsnotify v1.5.2/go.mod h1:VKyWoa5earkjWzuYFJOy3s0DLrlWgSh5nf5hjFuJcAw=
-github.com/fsnotify/fsnotify v1.5.3 h1:vNFpj2z7YIbwh2bw7x35sqYpp2wfuq+pivKbWG09B8c=
-github.com/fsnotify/fsnotify v1.5.3/go.mod h1:T3375wBYaZdLLcVNkcVbzGHY7f1l/uK5T5Ai1i3InKU=
-github.com/fsnotify/fsnotify v1.5.4 h1:jRbGcIw6P2Meqdwuo0H1p6JVLbL5DHKAKlYndzMwVZI=
-github.com/fsnotify/fsnotify v1.5.4/go.mod h1:OVB6XrOHzAwXMpEM7uPOzcehqUV2UqJxmVXmkdnm1bU=
-github.com/fsnotify/fsnotify v1.6.0 h1:n+5WquG0fcWoWp6xPWfHdbskMCQaFnG6PfBrh1Ky4HY=
-github.com/fsnotify/fsnotify v1.6.0/go.mod h1:sl3t1tCWJFWoRz9R8WJCbQihKKwmorjAbSClcnxKAGw=
 github.com/fsnotify/fsnotify v1.9.0 h1:2Ml+OJNzbYCTzsxtv8vKSFD9PbJjmhYF14k/jKC7S9k=
 github.com/fsnotify/fsnotify v1.9.0/go.mod h1:8jBTzvmWwFyi3Pb8djgCCO5IBqzKJ/Jwo8TRcHyHii0=
-github.com/golang/protobuf v1.5.0/go.mod h1:FsONVRAS9T7sI+LIUmWTfcYkHO4aIWwzhcaSAoJOfIk=
-github.com/golang/protobuf v1.5.2 h1:ROPKBNFfQgOUMifHyP+KYbvpjbdoFNs+aK7DXlji0Tw=
-github.com/golang/protobuf v1.5.2/go.mod h1:XVQd3VNwM+JqD3oG2Ue2ip4fOMUkwXdXDdiuN0vRsmY=
-github.com/golang/protobuf v1.5.3 h1:KhyjKVUg7Usr/dYsdSqoFveMYd5ko72D+zANwlG1mmg=
-github.com/golang/protobuf v1.5.3/go.mod h1:XVQd3VNwM+JqD3oG2Ue2ip4fOMUkwXdXDdiuN0vRsmY=
 github.com/golang/protobuf v1.5.4 h1:i7eJL8qZTpSEXOPTxNKhASYpMn+8e5Q6AdndVa1dWek=
 github.com/golang/protobuf v1.5.4/go.mod h1:lnTiLA8Wa4RWRcIUkrtSVa5nRhsEGBg48fD6rSs7xps=
-github.com/google/go-cmp v0.5.5/go.mod h1:v8dTdLbMG2kIc/vJvl+f65V22dbkXbowE6jgT/gNBxE=
-github.com/google/go-cmp v0.5.7 h1:81/ik6ipDQS2aGcBfIN5dHDB36BwrStyeAQquSYCV4o=
-github.com/google/go-cmp v0.5.7/go.mod h1:n+brtR0CgQNWTVd5ZUFpTBC8YFBDLK/h/bpaJ8/DtOE=
-github.com/google/go-cmp v0.5.8 h1:e6P7q2lk1O+qJJb4BtCQXlK8vWEO8V1ZeuEdJNOqZyg=
-github.com/google/go-cmp v0.5.8/go.mod h1:17dUlkBOakJ0+DkrSSNjCkIjxS6bF9zb3elmeNGIjoY=
-github.com/google/go-cmp v0.5.9 h1:O2Tfq5qg4qc4AmwVlvv0oLiVAGB7enBSJ2x2DqQFi38=
-github.com/google/go-cmp v0.5.9/go.mod h1:17dUlkBOakJ0+DkrSSNjCkIjxS6bF9zb3elmeNGIjoY=
 github.com/google/go-cmp v0.7.0 h1:wk8382ETsv4JYUZwIsn6YpYiWiBsYLSJiTsyBybVuN8=
 github.com/google/go-cmp v0.7.0/go.mod h1:pXiqmnSA92OHEEa9HXL2W4E7lf9JzCmGVUdgjX3N/iU=
 github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1 h1:EGx4pi6eqNxGaHF6qqu48+N2wcFQ5qg5FXgOdqsJ5d8=
@@ -56,8 +16,6 @@ github.com/jaschaephraim/lrserver v0.0.0-20171129202958-50d19f603f71 h1:24NdJ5N6
 github.com/jaschaephraim/lrserver v0.0.0-20171129202958-50d19f603f71/go.mod h1:ozZLfjiLmXytkIUh200wMeuoQJ4ww06wN+KZtFP6j3g=
 github.com/jtolds/gls v4.20.0+incompatible h1:xdiiI2gbIgH/gLH7ADydsJ1uDOEzR8yvV7C0MuV77Wo=
 github.com/jtolds/gls v4.20.0+incompatible/go.mod h1:QJZ7F/aHp+rZTRtaJ1ow/lLfFfVYBRgL+9YlvaHOwJU=
-github.com/mattn/go-shellwords v1.0.11 h1:vCoR9VPpsk/TZFW2JwK5I9S0xdrtUq2bph6/YjEPnaw=
-github.com/mattn/go-shellwords v1.0.11/go.mod h1:EZzvwXDESEeg03EKmM+RmDnNOPKG4lLtQsUlTZDWQ8Y=
 github.com/mattn/go-shellwords v1.0.12 h1:M2zGm7EW6UQJvDeQxo4T51eKPurbeFbe8WtebGE2xrk=
 github.com/mattn/go-shellwords v1.0.12/go.mod h1:EZzvwXDESEeg03EKmM+RmDnNOPKG4lLtQsUlTZDWQ8Y=
 github.com/smartystreets/assertions v1.2.0 h1:42S6lae5dvLc7BrLu/0ugRtcFVjoJNMC/N3yZFZkDFs=
@@ -67,25 +25,12 @@ github.com/smartystreets/goconvey v1.7.2/go.mod h1:Vw0tHAZW6lzCRk3xgdin6fKYcG+G3
 golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=
 golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg=
 golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
-golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c h1:F1jZWGFhYfh0Ci55sIpILtKKK8p3i2/krTr0H1rg74I=
-golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.0.0-20220412211240-33da011f77ad h1:ntjMns5wyP/fN65tdBD4g8J5w8n015+iIIs9rtjXkY0=
-golang.org/x/sys v0.0.0-20220412211240-33da011f77ad/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.0.0-20220908164124-27713097b956 h1:XeJjHH1KiLpKGb6lvMiksZ9l0fVUh+AmGcm0nOMEBOY=
-golang.org/x/sys v0.0.0-20220908164124-27713097b956/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.28.0 h1:Fksou7UEQUWlKvIdsqzJmUmCX3cZuD2+P3XyyzwMhlA=
-golang.org/x/sys v0.28.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
 golang.org/x/sys v0.32.0 h1:s77OFDvIQeibCmezSnk/q6iAfkdiQaJi4VzroCFrN20=
 golang.org/x/sys v0.32.0/go.mod h1:BJP2sWEmIv4KK5OTEluFJCKSidICx8ciO85XgH3Ak8k=
+golang.org/x/sys v0.33.0 h1:q3i8TbbEz+JRD9ywIRlyRAQbM0qF7hu24q3teo2hbuw=
+golang.org/x/sys v0.33.0/go.mod h1:BJP2sWEmIv4KK5OTEluFJCKSidICx8ciO85XgH3Ak8k=
 golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/tools v0.0.0-20190328211700-ab21143f2384/go.mod h1:LCzVGOaR6xXOjkQ3onu1FJEFr0SW1gC7cKk1uF8kGRs=
-golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543 h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4=
-golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
-google.golang.org/protobuf v1.26.0-rc.1/go.mod h1:jlhhOSvTdKEhbULTjvd4ARK9grFBp09yW+WbY/TyQbw=
-google.golang.org/protobuf v1.26.0 h1:bxAC2xTBsZGibn2RTntX0oH50xLsqy1OxA9tTL3p/lk=
-google.golang.org/protobuf v1.26.0/go.mod h1:9q0QmTI4eRPtz6boOQmLYwt+qCgq0jsYwAQnmE0givc=
-google.golang.org/protobuf v1.28.0 h1:w43yiav+6bVFTBQFZX0r7ipe9JQ1QsbMgHwbBziscLw=
-google.golang.org/protobuf v1.28.0/go.mod h1:HV8QOd/L58Z+nl8r43ehVNZIU/HEI6OcFqwMG9pJV4I=
 google.golang.org/protobuf v1.36.3 h1:82DV7MYdb8anAVi3qge1wSnMDrnKK7ebr+I0hHRN1BU=
 google.golang.org/protobuf v1.36.3/go.mod h1:9fA7Ob0pmnwhb644+1+CVWFRbNajQ6iRojtC/QF5bRE=
 gopkg.in/fsnotify.v1 v1.4.7 h1:xOHLXZwVvI9hhs+cLKq5+I5onOuwQLhQwiu63xxlHs4=
diff --git a/repositories.bzl b/repositories.bzl
index cc7e6dd..4ddee7c 100644
--- a/repositories.bzl
+++ b/repositories.bzl
@@ -6,33 +6,33 @@ def go_repositories():
     go_repository(
         name = "com_github_fsnotify_fsevents",
         importpath = "github.com/fsnotify/fsevents",
+        patches = ["//:third_party/fsnotify/fsevents/pr_38.diff"],
         sum = "h1:/125uxJvvoSDDBPen6yUZbil8J9ydKZnnl3TWWmvnkw=",
         version = "v0.1.1",
-        patches = ["//:third_party/fsnotify/fsevents/pr_38.diff"],
     )
     go_repository(
         name = "com_github_fsnotify_fsnotify",
         importpath = "github.com/fsnotify/fsnotify",
-        sum = "h1:hsms1Qyu0jgnwNXIxa+/V/PDsU6CfLf6CNO8H7IWoS4=",
-        version = "v1.4.9",
+        sum = "h1:2Ml+OJNzbYCTzsxtv8vKSFD9PbJjmhYF14k/jKC7S9k=",
+        version = "v1.9.0",
     )
     go_repository(
         name = "com_github_golang_protobuf",
         importpath = "github.com/golang/protobuf",
-        sum = "h1:oOuy+ugB+P/kBdUnG5QaMXSIyJ1q38wWSojYCb3z5VQ=",
-        version = "v1.4.0",
+        sum = "h1:i7eJL8qZTpSEXOPTxNKhASYpMn+8e5Q6AdndVa1dWek=",
+        version = "v1.5.4",
     )
     go_repository(
         name = "com_github_google_go_cmp",
         importpath = "github.com/google/go-cmp",
-        sum = "h1:xsAVV57WRhGj6kEIi8ReJzQlHHqcBYCElAvkovg3B/4=",
-        version = "v0.4.0",
+        sum = "h1:wk8382ETsv4JYUZwIsn6YpYiWiBsYLSJiTsyBybVuN8=",
+        version = "v0.7.0",
     )
     go_repository(
         name = "com_github_gorilla_websocket",
         importpath = "github.com/gorilla/websocket",
-        sum = "h1:q7AeDBpnBk8AogcD4DSag/Ukw/KV+YhzLj2bP5HvKCM=",
-        version = "v1.4.1",
+        sum = "h1:PPwGk2jz7EePpoHN/+ClbZu8SPxiqlu12wZP/3sWmnc=",
+        version = "v1.5.0",
     )
     go_repository(
         name = "com_github_jaschaephraim_lrserver",
@@ -41,16 +41,22 @@ def go_repositories():
         version = "v0.0.0-20171129202958-50d19f603f71",
     )
     go_repository(
-        name = "org_golang_x_sys",
-        importpath = "golang.org/x/sys",
-        sum = "h1:S/FtSvpNLtFBgjTqcKsRpsa6aVsI6iztaz1bQd9BJwE=",
-        version = "v0.0.0-20191029155521-f43be2a4598c",
+        name = "com_github_mattn_go_shellwords",
+        importpath = "github.com/mattn/go-shellwords",
+        sum = "h1:M2zGm7EW6UQJvDeQxo4T51eKPurbeFbe8WtebGE2xrk=",
+        version = "v1.0.12",
     )
     go_repository(
         name = "org_golang_google_protobuf",
         importpath = "google.golang.org/protobuf",
-        sum = "h1:qdOKuR/EIArgaWNjetjgTzgVTAZ+S/WXVrq9HW9zimw=",
-        version = "v1.21.0",
+        sum = "h1:82DV7MYdb8anAVi3qge1wSnMDrnKK7ebr+I0hHRN1BU=",
+        version = "v1.36.3",
+    )
+    go_repository(
+        name = "org_golang_x_sys",
+        importpath = "golang.org/x/sys",
+        sum = "h1:q3i8TbbEz+JRD9ywIRlyRAQbM0qF7hu24q3teo2hbuw=",
+        version = "v0.33.0",
     )
     go_repository(
         name = "org_golang_x_xerrors",
@@ -58,9 +64,3 @@ def go_repositories():
         sum = "h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4=",
         version = "v0.0.0-20191204190536-9bdfabe68543",
     )
-    go_repository(
-        name = "com_github_mattn_go_shellwords",
-        importpath = "github.com/mattn/go-shellwords",
-        sum = "h1:Y7Xqm8piKOO3v10Thp7Z36h4FYFjt5xB//6XvOrs2Gw=",
-        version = "v1.0.10",
-    )
