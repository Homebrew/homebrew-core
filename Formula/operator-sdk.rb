class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git", :tag => "v0.8.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "545750503987405b358ffceee14b54f3a8f5e300fd0bfe4ea8ac5277c82a3253" => :mojave
    sha256 "8d462c4eaba6ebbefd0693fefe46294f9bdfa6f42b71408e9a9b2520044732a1" => :high_sierra
    sha256 "194749da995e4458e11504ba1859298906f837dbdd964f9af36c21e1366abf5b" => :sierra
  end

  depends_on "dep"
  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/operator-framework/operator-sdk"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Make binary
      system "make", "install"
      bin.install buildpath/"bin/operator-sdk"

      # Install bash completion
      output = Utils.popen_read("#{bin}/operator-sdk completion bash")
      (bash_completion/"operator-sdk").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/operator-sdk completion zsh")
      (zsh_completion/"_operator-sdk").write output

      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "on"
    dir = testpath/"src/example.com/test-operator"
    dir.mkpath

    cd dir do
      # Create a new, blank operator framework
      system "#{bin}/operator-sdk", "new", "test"
    end
  end
end
