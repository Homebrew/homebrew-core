class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.9.0",
      :revision => "560208dc998de497bbf59fea1b63426aec430934"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33202cb5bc7c7b3cd1346dc3a1f1ed982eb8676e5a073d21096af80d5a81efcd" => :mojave
    sha256 "d62d8575f0644820dad5b3fb0f3268d99e9cdc79f11c3ed8726d2d19ed807ae8" => :high_sierra
    sha256 "2b29884d4da7b99a7bb242621a3cf460b979a130041289b7062b8b8ea6dee9a2" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/operator-framework/operator-sdk"
    src.install buildpath.children
    src.cd do
      # Make binary
      system "make", "build/operator-sdk-#{stable.specs[:tag]}-x86_64-apple-darwin"
      bin.install "build/operator-sdk-v0.9.0-x86_64-apple-darwin" => "operator-sdk"

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
    cd testpath/"src" do
      # Create a new, blank operator framework
      system "#{bin}/operator-sdk", "new", "test", "--skip-validation"
    end
  end
end
