class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.50.tar.gz"
  sha256 "e6bd27bd4e40617c69fa4a888408ac12bb00e49679ff16afd4561407ade87e51"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "354259e2ac7e72cb36dab1a50205732b54044712064de8c53c86ebbead2fe0e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "11fd37722cdcfbb47fe1490dc65407c271103f668bfa6bef47f1753a8dba0cdd"
    sha256 cellar: :any_skip_relocation, catalina:      "17f0e0fdbb0a3975ceafb96902729422daa4bffaedbb725236db6626986bd3f0"
    sha256 cellar: :any_skip_relocation, mojave:        "95312887809e8555929a4b0c6c80f81c5535a0587fb874c039ed9798888d8b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ba391d0bab972aed0d5691e1794b3a1c2a20a0ea4eaf1874c6a77ad217138e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
