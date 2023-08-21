class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.24.1",
      revision: "b873fb3ccde645d1a759289fa85eec329ec49b73"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41cb2b6a0f243d1d74d0353bb9dbf89cda839c2824c3a32f7dce79eed1d203e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41cb2b6a0f243d1d74d0353bb9dbf89cda839c2824c3a32f7dce79eed1d203e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a41cb2b6a0f243d1d74d0353bb9dbf89cda839c2824c3a32f7dce79eed1d203e"
    sha256 cellar: :any_skip_relocation, ventura:        "20afad98ce158b73ea063c11e5116d014a140a0e4ab12647b2ac84bc2785e0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "20afad98ce158b73ea063c11e5116d014a140a0e4ab12647b2ac84bc2785e0e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "20afad98ce158b73ea063c11e5116d014a140a0e4ab12647b2ac84bc2785e0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c29414ecadd7fe6d1a0628d3c082dfe11ec5e0de7bb7214ff44c6373bfe9a1e"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
