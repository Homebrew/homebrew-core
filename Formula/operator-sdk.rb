class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.15.1",
      :revision => "e35ec7b722ba095e6438f63fafb9e7326870b486"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 "36bd29be1646d2e2691296528fe3fedce0d8f742befc1ed427dee8a984b05e84" => :catalina
    sha256 "af025fa4d9fe09c97f4b20cb97aa51015fbd3bc72b120b484a7ae0f225740327" => :mojave
    sha256 "0270e820c9dd9a9f9d110feb6ab412330582c36f93b7f9152101c6d86a173ef9" => :high_sierra
  end

  depends_on "go"

  def install
    # TODO: Do not set GOROOT. This is a fix for failing tests when compiled with Go 1.13.
    # See https://github.com/Homebrew/homebrew-core/pull/43820.
    ENV["GOROOT"] = Formula["go"].opt_libexec

    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/operator-framework/operator-sdk"
    dir.install buildpath.children - [buildpath/".brew_home"]
    dir.cd do
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
    # Use the offical golang module cache to prevent network flakes and allow
    # this test to complete before timing out.
    ENV["GOPROXY"] = "https://proxy.golang.org"

    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      assert_match stable.specs[:revision], version_output
    end

    # Create a new, blank operator
    system "#{bin}/operator-sdk", "new", "test", "--repo=github.com/example-inc/app-operator"

    cd "test" do
      # Add an example API resource. This exercises most of the various pieces
      # of generation logic.
      system "#{bin}/operator-sdk", "add", "api", "--api-version=app.example.com/v1alpha1", "--kind=AppService"
    end
  end
end
