class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.9.0",
      :revision => "560208dc998de497bbf59fea1b63426aec430934"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f11a93f335489bd5ed27b3e296ea947e772efebfc434fa96af9fc567603277f" => :mojave
    sha256 "11f706a313d0af27e25e816abd89e94fabc022f00f88f36c420d4d35829c3ecb" => :high_sierra
    sha256 "13d461d6b758400847271eeeb681a61417dce9ac5734ac9fc90db41647c567f8" => :sierra
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
