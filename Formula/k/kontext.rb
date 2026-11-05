class Kontext < Formula
  desc "Identity, credentials, and governance for AI agents"
  homepage "https://kontext.security"
  url "https://github.com/kontext-security/kontext/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "354d8984d0976d7f5d1259e90e1e533efbbcbb772b47d937fc0dff3b87780dfc"
  license "MIT"
  head "https://github.com/kontext-security/kontext.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcce1920938f40682596a6c80a72890371b8cd40616ee073dd9acd3d9ad7d9b7"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X github.com/kontext-security/kontext/internal/buildinfo.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kontext"

    generate_completions_from_executable(bin/"kontext", shell_parameter_format: :cobra)
  end

  test do
    assert_match "#{version} (built by #{tap.user})", shell_output("#{bin}/kontext --version")

    settings = shell_output("#{bin}/kontext claude managed-settings template --kontext-binary #{bin}/kontext")
    (testpath/"settings.json").write settings
    assert_match "Claude managed settings valid",
      shell_output("#{bin}/kontext claude managed-settings validate #{testpath}/settings.json " \
                   "--kontext-binary #{bin}/kontext")

    assert_match "managed config not found", shell_output("#{bin}/kontext whoami 2>&1", 1)
  end
end
