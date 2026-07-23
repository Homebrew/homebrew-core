class Cloudmonkey < Formula
  desc "Apache CloudStack CloudMonkey CLI"
  homepage "https://github.com/apache/cloudstack-cloudmonkey"
  url "https://github.com/apache/cloudstack-cloudmonkey/archive/refs/tags/6.5.0.tar.gz"
  sha256 "bb491140103f0d8c178966355114f0eb9b35ad64323fba7448d475112d8847fc"
  license "Apache-2.0"
  head "https://github.com/apache/cloudstack-cloudmonkey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1490cc95342f8f115d03ce856e547208156583c9360f54210c18290fc541497d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1490cc95342f8f115d03ce856e547208156583c9360f54210c18290fc541497d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1490cc95342f8f115d03ce856e547208156583c9360f54210c18290fc541497d"
    sha256 cellar: :any_skip_relocation, sonoma:        "29816db5756c41031db6098d2d453b4184b7d8dfdc7ca051343310a30110c057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb80ac5c6075ba9f3bf0cda30ba0c94ef12d25516b9e3d7a4c77324c4cd42777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af20640052fa68160801c48ec53c89302f01cd73e348a8d332b5f34046b929f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitSHA=homebrew -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "release", output: bin/"cmk"),
           "cmk.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmk -v")

    config_file = testpath/"cmk.ini"
    touch config_file

    # `set` writes through the INI config layer without any network calls;
    # this exercises config init, profile defaults, and key updates.
    system bin/"cmk", "-c", config_file, "set", "asyncblock", "false"
    assert_path_exists config_file
    assert_match(/^asyncblock\s*=\s*false$/, config_file.read)
  end
end
