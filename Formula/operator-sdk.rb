class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.18.0",
      :revision => "921c33982687d6e9219fe0a1a326515fb37ae040"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 "6570563756f80fd7b2c87ddb308cb7eb1829844695f6e26e71a5a613b4485e02" => :catalina
    sha256 "8ccb6bdb1250d0a34fbe95e50187a8553ae96dd1a6bb925420a88172980ef994" => :mojave
    sha256 "ae15974aa0e6882117cd92046cd9ba743c457b3686fca13e6b25d1209a90e699" => :high_sierra
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
      output = Utils.safe_popen_read("#{bin}/operator-sdk completion bash")
      (bash_completion/"operator-sdk").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/operator-sdk completion zsh")
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
