class OpenFeatureCli < Formula
  desc "Command-line tool for managing feature flags across environments"
  homepage "https://openfeature.dev"
  url "https://github.com/open-feature/cli/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3a1c398d022006ac90223679e4fc7dd5b277e5302fe6aec466fca8ad1a692ee4"
  license "Apache-2.0"
  head "https://github.com/open-feature/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=unknown
      -X main.date=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # The CLI doesn't currently support shell completions
    # Will need to be updated when/if it adds this feature
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfeature version")
    
    # Create a basic flag manifest
    system bin/"openfeature", "init", "--no-input", "--name", "test-flags"
    assert_predicate testpath/"flag-manifest.yaml", :exist?
    assert_match "name: test-flags", (testpath/"flag-manifest.yaml").read
  end
end