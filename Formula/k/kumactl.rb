class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.7.2.tar.gz"
  sha256 "76a76f381b42760903a2f4652a334c3622196bee64858225333476c5a2c77ed8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5336ef86ce91709fc372da5319e1b360aed77c313ce620a789a42d57cc03000d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f081783c316b440090744a4980fbc5b449ad2798d58185ee66ba1d034a46dd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afdd1cd39f96b450bf49ee458dd75c3c1fe6d04db2708a7342dd4ad8818fdb3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "aae887fd306fedb0e8d8e1b72d28bc09f0579be94c7422e30cfc22733aefbdbf"
    sha256 cellar: :any_skip_relocation, ventura:        "54a8b8823e52d80c705207b214800762bdea024ccc6de7a487ac248eac133ade"
    sha256 cellar: :any_skip_relocation, monterey:       "40dcbe99b3be32f40ad66e2032d5cb52284bb5acb957c7c620082367f44c827e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f7013b8bc5f0e40081571287c4592e32f66242d5e5125578e0e2395d8b479d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
