class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.13.2",
      revision: "829f36abd73a6e85757869e998516368800e63a5"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55ed882f0c18ce903062bf014a01f846bb0fdf8dd4411a6050dbc877430d160e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86da66f8b5cf43631ef1b5921c0f0f6de804717aae8e99ede463107d3dc383b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b154808bb45d5638376e1ee0ae52c059cc0d65bafd6e384384cfed69fc918b0d"
    sha256 cellar: :any_skip_relocation, ventura:        "9bce51ef45897a5c7c8a30ada63ac1076ef14f95385ab2bf2e87a1a2b295f246"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b2c07b35faa272dcd9b02e6c171419d36b22693c0002f9c34bc461db639c9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "765c686973bb298177672e6d084407f9e5b91b4113bd5f4fcdfcded6036fbdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e286e0619901f2840e75946d5a2b10b95c4a1be5beb27e095360a69fc6ee4334"
  end

  depends_on "go" => :build

  # Enable completions, remove after merged and released
  patch do
    url "https://github.com/lacework/go-sdk/commit/750bad27d89fe925a9f69377a87bc738907aecff.patch?full_index=1"
    sha256 "aa962fbaf173503a67c7bf86c5120f76723a983f7f3e118484bf0ae102c13cc6"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
