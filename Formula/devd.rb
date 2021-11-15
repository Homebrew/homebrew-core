class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.9.tar.gz"
  sha256 "5aee062c49ffba1e596713c0c32d88340360744f57619f95809d01c59bff071f"
  license "MIT"
  head "https://github.com/cortesi/devd.git"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066a8cb9c2a379b7b4c77476dcad100ef1b50ca211717460de1b23727f540e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1adc7ff42fb9063f2724578755a548a4b52244269c03ffef599bad06da2641d0"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a739aeae1644c64f5dde53190c6050ecf28ff7ae06867e604679391684c5df"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a80a457e6b056c0b00d9b1dbbce26c18c36285e4296100d1196875988ee6b7c"
    sha256 cellar: :any_skip_relocation, catalina:       "5a1dceea4de81075bab6e0617b38c39f715423c4e8e0d17f75f65d7e15cf7dee"
    sha256 cellar: :any_skip_relocation, mojave:         "33c299776d5aa228d68b36d9d51af12b04d5e65a194b907900bd117882a45f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d3cb4f63a05ccd30e3e819940ce9f7f50732d4478a04a65cb6d54d31852a7c"
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # Patch is the `dep` equivalent of https://github.com/cortesi/devd/pull/117
  patch :DATA

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    cd "src/github.com/cortesi/devd" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/devd"
    end
  end

  test do
    (testpath/"www/example.txt").write <<~EOS
      Hello World!
    EOS

    port = free_port
    fork { exec "#{bin}/devd", "--port=#{port}", "#{testpath}/www" }
    sleep 2

    output = shell_output("curl --silent 127.0.0.1:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end

__END__
diff --git a/Gopkg.lock b/Gopkg.lock
index 437a8b5..257a307 100644
--- a/Gopkg.lock
+++ b/Gopkg.lock
@@ -172,14 +172,15 @@

 [[projects]]
   branch = "master"
-  digest = "1:e6d1805ead5b8f2439808f76187f54042ed35ee26eb9ca63127259a0e612b119"
+  digest = "1:d5b479606f9456b8e3200dbe988b32e211f824d6a612c4cfac46c1a31458d568"
   name = "golang.org/x/sys"
   packages = [
+    "internal/unsafeheader",
     "unix",
     "windows",
   ]
   pruneopts = ""
-  revision = "b4a75ba826a64a70990f11a225237acd6ef35c9f"
+  revision = "63515b42dcdf9544f4e6a02fd7632793fde2f72d"

 [[projects]]
   digest = "1:15d017551627c8bb091bde628215b2861bed128855343fdd570c62d08871f6e1"
