class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  version "2.120.0"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url "https://github.com/jfrog/jfrog-cli/releases/latest"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/#{version}/jfrog-cli-mac-arm64/jf"
      sha256 "794d46c200cd1906b067151a159b8f5c8066cc9aacaf6e1330b178ee58fb581c"
    end
    on_intel do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/#{version}/jfrog-cli-mac-386/jf"
      sha256 "ec3b67425c83378ff0ceb4d78bd106da8946564db1cb7f79ec0d8457d25c48aa"
    end
  end

  on_linux do
    on_arm do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/#{version}/jfrog-cli-linux-arm64/jf"
      sha256 "7ff002f099c611d2d2c90353275a417fe1254490f1bd63f13ab24aaff5452b5c"
    end
    on_intel do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/#{version}/jfrog-cli-linux-amd64/jf"
      sha256 "9ec57d052c478719ac72f6ce25ffdb068952640214e3140052da854187c812b1"
    end
  end

  def install
    bin.install "jf"
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("\#{bin}/jf -v")
    assert_match version.to_s, shell_output("\#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("\#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
      docs = shell_output("\#{bin}/jf api docs search permission --format json")
      assert_match '"spec_bundle": "full"', docs
    end
  end
end
