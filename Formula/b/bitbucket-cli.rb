class BitbucketCli < Formula
  desc "Bitbucket command-line tool"
  homepage "https://bitbucket.org/gildas_cherruel/bb"
  url "https://bitbucket.org/gildas_cherruel/bb/get/bd28627ccf0f62e3773fe7e14659456c8109c9da.tar.gz"
  version "0.8.0"
  sha256 "df0173e7fe514cf635ade0b6f23862ef81d70308ff591b4473e15a32b0e18ca5"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(output: bin/"bb", ldflags: "-s -w")
    generate_completions_from_executable(bin/"bb", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "bb version #{version}", shell_output("#{bin}/bb --version")
  end
end
