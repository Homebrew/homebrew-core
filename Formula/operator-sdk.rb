class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk/archive/v0.7.1.tar.gz"
  sha256 "c6d5e41c5811cfe73554f5fe03a391bb6bcce641d8d7d412fd7c245c6240d081"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efe5cd2b282a1738fbce328f11296ddfbfafd779b6db145103a7a6c33813c486" => :mojave
    sha256 "31029ccc2203785d458bfaa5539fb5323a9f93d2af2fa29130ec1fb17609b889" => :high_sierra
    sha256 "f0c621fc927962e65d804407ce928430c700d2d275d4625da6e45ed441963731" => :sierra
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
