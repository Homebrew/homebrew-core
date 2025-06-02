class Hishtory < Formula
  desc "Your shell history: synced, queryable, and in context"
  homepage "https://hishtory.dev"
  url "https://github.com/ddworken/hishtory/archive/refs/tags/v0.335.tar.gz"
  sha256 "f312acc99195ca035db7b6612408169ce3a14c170f85dba238f9a29ca7825a3d"
  license "MIT"
  head "https://github.com/ddworken/hishtory.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34db19bb53a5227bdda758dd4511b3268bba2a5edf4e97ab312d96a164f8c24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34db19bb53a5227bdda758dd4511b3268bba2a5edf4e97ab312d96a164f8c24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e34db19bb53a5227bdda758dd4511b3268bba2a5edf4e97ab312d96a164f8c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "d98870cb4d2d3427a139d11dbc40b9e8d94bea42b3be326074fb72363c8bd1fa"
    sha256 cellar: :any_skip_relocation, ventura:       "c406a562034cc2bdd76625c79616e6bf7362857cd0964c13636d5660a241f1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff41cdcf4490c139d740a547cc565febf4326cc11d86ca2cd87eb49f615c73c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ddworken/hishtory/client/lib.Version=#{version}
      -X github.com/ddworken/hishtory/client/lib.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hishtory", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hishtory --version")

    output = shell_output("#{bin}/hishtory init")
    assert_match "Setting secret hishtory key", output

    assert_match "Enabled: true", shell_output("#{bin}/hishtory status")
  end
end
