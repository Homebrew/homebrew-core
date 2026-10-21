class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  stable do
    url "https://github.com/databricks/click/archive/refs/tags/v0.6.3.tar.gz"
    sha256 "da64d1d205b6136f318dea967eec4e9d67569be8f332875afcc6b31c9a0ef1b7"

    # Backport Cargo.lock updates
    patch do
      url "https://github.com/databricks/click/commit/b3bf1ab6faccf0693dc134500c826f9a8b647ec7.patch?full_index=1"
      sha256 "756a8c2f41786778d040e552bc03177609ab81b0fe807ba838db785e9fb9eece"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2b106cad284cc001d5c47eec4aef326ffb6cf54c454c58307d8b7ecd7aaebba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40cf8f177a79ec8c1c80268788b4a60fc9723fe5badff33aa6e61c05c6235e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a877b7525e77625b581f2dcbbbaa68a275be940e42f15a1de288a1b5e8a7894"
    sha256 cellar: :any,                 arm64_linux:       "5e8615398b22331965b721690977a47a9a7545b13f04accb2d8ce431e2d76dbc"
    sha256 cellar: :any,                 x86_64_linux:      "bfeedb08a341b3ce7c393b7365695e6639a71d8d4269e69e966bc3794a4dc4d2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Default state configuration file to avoid warning on startup
    (testpath/"config/click.config").write <<~YAML
      ---
      namespace: ~
      context: ~
      editor: ~
      terminal: ~
    YAML

    # Fake K8s configuration
    (testpath/"config/config").write <<~YAML
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https://localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences:
        colors: true
      users:
        - name: test-cluster
          user:
            client-certificate-data: >-
              invalid
            client-key-data: >-
              invalid
    YAML

    # This test cannot test actual K8s connectivity, but it is enough to prove click starts
    output = pipe_output("#{bin}/click --config_dir #{testpath}/config", "quit")
    assert_equal "[\e[38;5;9m\e[1mnone\e[0m] [\e[38;5;10m\e[1mnone\e[0m] [\e[38;5;3mnone\e[39m] > ", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 5bb9043..81a81b8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1168,9 +1168,9 @@ checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.9.3",
  "cfg-if",
@@ -1200,9 +1200,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
