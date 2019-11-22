class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.123.0",
      :revision => "30da2ee18207ecc706e92df4b8b0f5a11214d745"

  bottle do
    cellar :any_skip_relocation
    sha256 "1988460a8795c520d0e8153f1cf0a752c78be87886e81538f4cb7dfa53e1f20a" => :catalina
    sha256 "2e41b430cd9097b5418f32cc7b19d16b219a4314ac9d0cdfec7015331d9db7f5" => :mojave
    sha256 "fe96ee4592ef21ba36bd9f2c63efc4a71de5da8db85eaa3f02679a7965f39e9c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
