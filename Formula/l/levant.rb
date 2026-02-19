class Levant < Formula
  desc "Templating and deployment tool for HashiCorp Nomad jobs"
  homepage "https://github.com/hashicorp/levant"
  url "https://github.com/hashicorp/levant/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8d299e890af5a3c6e9048f930b10cd34276656142358c298497ec5d7d8efa263"
  license "MPL-2.0"
  head "https://github.com/hashicorp/levant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb81bbf1ee7ccd3049ba2bc72a14b98875486cdbd4c265af23d6742e7130e88c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c69cd2cf967901c3d86200eefb085070fcbee97867ab84ea8631ccf97d9aafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c69cd2cf967901c3d86200eefb085070fcbee97867ab84ea8631ccf97d9aafe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c69cd2cf967901c3d86200eefb085070fcbee97867ab84ea8631ccf97d9aafe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4237a1b7e9431f1da4b05740ff17ad96c0c0b3be6925ed006c5b6e7ebc3bc477"
    sha256 cellar: :any_skip_relocation, ventura:       "4237a1b7e9431f1da4b05740ff17ad96c0c0b3be6925ed006c5b6e7ebc3bc477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c019ee7b60f8858c88b5823ad0e7ff4d37033027a2874870b46b1b721a084a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4739b4cea3ef654bf8ab6990fd0a5ff827a7248619fc095439e88311e416af3"
  end

  deprecate! date: "2025-06-27", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/levant/version.Version=#{version}
      -X github.com/hashicorp/levant/version.VersionPrerelease=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"template.nomad").write <<~HCL
      resources {
          cpu    = [[.resources.cpu]]
          memory = [[.resources.memory]]
      }
    HCL

    (testpath/"variables.json").write <<~JSON
      {
        "resources":{
          "cpu":250,
          "memory":512,
          "network":{
            "mbits":10
          }
        }
      }
    JSON

    assert_match "resources {\n    cpu    = 250\n    memory = 512\n}\n",
      shell_output("#{bin}/levant render -var-file=#{testpath}/variables.json #{testpath}/template.nomad")

    assert_match "Levant v#{version}-#{tap.user}", shell_output("#{bin}/levant --version")
  end
end
