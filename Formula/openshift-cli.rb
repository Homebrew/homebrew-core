class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git"

  stable do
    url "https://github.com/openshift/oc.git",
        tag:      "openshift-clients-4.6.0-202006250705.p0",
        revision: "51011e4849252c723b520643d27d3fa164d28c61",
        shallow:  false
    version "4.6.0"

    # Add Makefile target to build arm64 binary
    # Upstream PR: https://github.com/openshift/oc/pull/889
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+)(?:[._-]p?\d+)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bdaeb2d2bb5a31dcc8048ec1da4567ce4917f4ef4c571c24907a6bab730fa685"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb1f2ce0b1741e9003b66883629b61d0ccfade7802b8ccc763aaccb629815177"
    sha256 cellar: :any_skip_relocation, catalina:      "5e8849de6efa9e03eda20c3bcffb7bdda0b26324d85d3b9f71ebdd1bfe198df0"
    sha256 cellar: :any_skip_relocation, mojave:        "dbeaf8a6fa3d95f78fd69a26140cdbdbee890f539e0419fc5c7757b587466ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98afc19240a133585d6f2303223744c933a0eb078b3b810c6ccd550ae1991bc"
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "heimdal" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = "darwin"
    on_linux do
      os = "linux"
      # See https://github.com/golang/go/issues/26487
      ENV.O0
    end
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/openshift/oc"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      args = ["cross-build-#{os}-#{arch}"]
      args << (build.stable? ? "WHAT=cmd/oc" : "WHAT=staging/src/github.com/openshift/oc/cmd/oc")
      on_linux { args << "SHELL=/bin/bash" }

      system "make", *args
      bin.install "_output/bin/#{os}_#{arch}/oc"

      bash_completion.install "contrib/completions/bash/oc"
      zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
    end
  end

  test do
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    context_output = shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")

    assert_match "foo", context_output
  end
end

__END__
diff --git a/Makefile b/Makefile
index 940a90415..a3584fbc9 100644
--- a/Makefile
+++ b/Makefile
@@ -88,6 +88,10 @@ cross-build-darwin-amd64:
 	+@GOOS=darwin GOARCH=amd64 $(MAKE) --no-print-directory build GO_BUILD_PACKAGES:=./cmd/oc GO_BUILD_FLAGS:="$(GO_BUILD_FLAGS_DARWIN)" GO_BUILD_BINDIR:=$(CROSS_BUILD_BINDIR)/darwin_amd64
 .PHONY: cross-build-darwin-amd64
 
+cross-build-darwin-arm64:
+	+@GOOS=darwin GOARCH=arm64 $(MAKE) --no-print-directory build GO_BUILD_PACKAGES:=./cmd/oc GO_BUILD_FLAGS:="$(GO_BUILD_FLAGS_DARWIN)" GO_BUILD_BINDIR:=$(CROSS_BUILD_BINDIR)/darwin_arm64
+.PHONY: cross-build-darwin-arm64
+
 cross-build-windows-amd64:
 	+@GOOS=windows GOARCH=amd64 $(MAKE) --no-print-directory build GO_BUILD_PACKAGES:=./cmd/oc GO_BUILD_FLAGS:="$(GO_BUILD_FLAGS_WINDOWS)" GO_BUILD_BINDIR:=$(CROSS_BUILD_BINDIR)/windows_amd64
 .PHONY: cross-build-windows-amd64
