class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.18.tar.gz"
  sha256 "b4c302181346f541533c6b43d526c5d4aad04ca95e10bc736c8e5bc227fab148"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f6d126910b625017e1efc2c43f1409742e6f1775fa0211d58aafd3fb2270d73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6d126910b625017e1efc2c43f1409742e6f1775fa0211d58aafd3fb2270d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6d126910b625017e1efc2c43f1409742e6f1775fa0211d58aafd3fb2270d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf307f2765dfb0e425d43a24ce8cb6c320a4755eafff70c6178addf5ce8ff7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c80d9249b31fea3f84fbcf6119f79e119682dbb817ac6452d152b2006f26537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abeb88cbfeef9f66bfa6fcc34f4b18bba7e38d896999256bd3295c547cbc800"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
