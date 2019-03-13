class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk/archive/v0.5.0.tar.gz"
  sha256 "2da85ed4d69da11344d935578cdd19ede0525804f66572081c53985e5a32c890"
  head "https://github.com/operator-framework/operator-sdk.git"

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
    dir = testpath/"src/example.com/test-operator"
    dir.mkpath

    cd dir do
      # Create a new, blank operator framework
      system "#{bin}/operator-sdk", "new", "test"
    end
  end
end
