class Q < Formula
  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/v3.1.6.tar.gz"
  sha256 "e63ba4ae49647f764c5255ad7065d2c614fdf03a2f7349a795de69529701fab8"

  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, monterey:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, catalina:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed14a331133ff96b85fa37e0729ca695bd273f78ee82e792185d137edf9917a"
  end

  depends_on "pyoxidizer" => :build
  depends_on "python@3.8" => :build
  depends_on "ronn" => :build
  depends_on xcode: ["12.4", :build]

  patch :DATA

  def install
    arch_folder = if OS.linux?
      "x86_64-unknown-linux-gnu"
    elsif Hardware::CPU.intel?
      "x86_64-apple-darwin"
    else
      "aarch64-apple-darwin"
    end

    system "pyoxidizer", "build", "--release", "--var", "PYTHON_VERSION", "3.9"
    bin.install "./build/#{arch_folder}/release/install/q"

    system "ronn", "--roff", "--section=1", "doc/USAGE.markdown"
    man1.install "doc/USAGE.1" => "q.1"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
__END__
diff --git a/pyoxidizer.bzl b/pyoxidizer.bzl
index da79ba2..8a27c4b 100644
--- a/pyoxidizer.bzl
+++ b/pyoxidizer.bzl
@@ -3,11 +3,13 @@
 # https://pyoxidizer.readthedocs.io/en/stable/ for details of this
 # configuration file format.
 
+PYTHON_VERSION = VARS.get("PYTHON_VERSION","3.8")
+
 # Configuration files consist of functions which define build "targets."
 # This function creates a Python executable and installs it in a destination
 # directory.
 def make_exe():
-    dist = default_python_distribution(python_version="3.8")
+    dist = default_python_distribution(python_version=PYTHON_VERSION)
 
     policy = dist.make_python_packaging_policy()
     policy.set_resource_handling_mode("classify")
