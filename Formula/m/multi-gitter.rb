class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "44114005fd83484a9a3f066aff58cc5d75607a6af14796eeb3c90ab45a70c211"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc05176fff40c5316f35fd8ebb64661efc2017bee9fe1fd7ff0cb8f0d9115e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc05176fff40c5316f35fd8ebb64661efc2017bee9fe1fd7ff0cb8f0d9115e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc05176fff40c5316f35fd8ebb64661efc2017bee9fe1fd7ff0cb8f0d9115e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2257dca26a7435580255465f33009d0c3b8ad02bc9d54ca6683e38f4277bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a215c4672845425df984d04ca25bd11920d4bdad89a53a6a6b6ed204e9cff103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c008865158a8066123236886afeca1ef27ae78ff7900bc755b299465c113003d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
