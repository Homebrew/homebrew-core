class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "4fb912a2127bdec75ada978954b3e9a963ec6891c95657237a3e4514da02b17f"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71157513185f9613482315d039748557eab8ef41af9e7eaee8a05e1eb9bda45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71157513185f9613482315d039748557eab8ef41af9e7eaee8a05e1eb9bda45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71157513185f9613482315d039748557eab8ef41af9e7eaee8a05e1eb9bda45c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da6109b355f11dad453a617befb34bb0ffed3ef85458a30490be832d7cfabca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0701d4d18cb780de35805f43764270f01a0b2c610d0d92634ea6595fbedaaf4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc7473e60befa9cb98228cabe0277d2d467ce930b2c20d51bccaf0917caf67f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
