class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.19.0",
      :revision => "8e28aca60994c5cb1aec0251b85f0116cc4c9427"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    rebuild 1
    sha256 "5b645526d83936c9b13eb77bdc5be0a28d299ddd70b8024a88848cfc20fde94c" => :catalina
    sha256 "04379c383bbb7bbe2bdc4517c7fedd865ff2fef97a95d5e70532a3f04f7d8545" => :mojave
    sha256 "9fee5fc8872a25065bb32febe4e4cb7fd8130242833a7a37c123e7f05b529c4e" => :high_sierra
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
      output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
      (bash_completion/"operator-sdk").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
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

    # Create an example AppService operator. This exercises most of the various pieces
    # of generation logic.
    args = ["--type=ansible", "--api-version=app.example.com/v1alpha1", "--kind=AppService"]
    system "#{bin}/operator-sdk", "new", "test", *args
    assert_predicate testpath/"test/requirements.yml", :exist?
  end
end
