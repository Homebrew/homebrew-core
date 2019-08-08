class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.10.0",
      :revision => "ff80b17737a6a0aade663e4827e8af3ab5a21170"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dd029800a64eab9ea04f49f60da816982cd3087ab47cb70e18e103c4f1390de" => :mojave
    sha256 "adef1143400f267b08bb7b470f48cc4be8afdb8d6a25bbf85d65a4e4aa8c1038" => :high_sierra
    sha256 "1f60ddd6915551a9c7dbad82402be2d05469544c14776662301eedaa71e4c4b1" => :sierra
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
      bin.install "build/operator-sdk-v0.10.0-x86_64-apple-darwin" => "operator-sdk"

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
