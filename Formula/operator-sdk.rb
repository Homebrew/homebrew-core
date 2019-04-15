class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk/archive/v0.7.0.tar.gz"
  sha256 "19c1fd70e4ca1242667552dc6a087bfeb2e019fffcfdbe2d7295475a7596126c"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6debfa6b81782848fabcb51a49f7215d43f971d5b578709e74c57ac1037327b1" => :mojave
    sha256 "19c9df8904b187338fb1f76ee4ee30db34bf61a010253eb14909e694c5095def" => :high_sierra
    sha256 "c6264a8515b083ab80d9d342899ee10b6f687f2063e7ae01c169e7cbbeaaae8d" => :sierra
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
    dir = testpath/"src/example.com/test-operator"
    dir.mkpath

    cd dir do
      # Create a new, blank operator framework
      system "#{bin}/operator-sdk", "new", "test"
    end
  end
end
