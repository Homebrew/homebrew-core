class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  stable do
    url "https://github.com/openshift/oc.git",
        tag:      "openshift-clients-4.6.0-202006250705.p0",
        revision: "51011e4849252c723b520643d27d3fa164d28c61"
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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1dd03d660dd23ec473ec2277e29f1d373220630544de94dae14eb70f69a350b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2782211e3255bb03ccf0b26f59d7ff859ca0324d45fb76b264cf44a16f3077ad"
    sha256 cellar: :any_skip_relocation, monterey:       "40e611652049dd41c3146947bd6f16185074b727fd969caa1e5494a0b9440f23"
    sha256 cellar: :any_skip_relocation, big_sur:        "870e98712efe5ea045356be3f36525c39e7cdef6239f68ec8c5957d750ae7022"
    sha256 cellar: :any_skip_relocation, catalina:       "f7a8fafdad3e268d2f8579c0c1500e4b1f45d247159986e0d3eed88f14672ea5"
    sha256 cellar: :any_skip_relocation, mojave:         "59b89010cda9ee308ff728704dccd919be1a12f3a1ea3454cf3f31e9c900d273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa2fe20e8fb4212f2ee01ea32ff1cfa255e1c5135f50ce27658b699de97ea49"
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "heimdal" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    args = ["cross-build-#{os}-#{arch}"]
    args << if build.stable?
      "WHAT=cmd/oc"
    else
      "WHAT=staging/src/github.com/openshift/oc/cmd/oc"
    end
    args << "SHELL=/bin/bash" if OS.linux?

    system "make", *args
    bin.install "_output/bin/#{os}_#{arch}/oc"

    bash_completion.install "contrib/completions/bash/oc"
    zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
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
