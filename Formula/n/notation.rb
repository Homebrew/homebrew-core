class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "541ee2d0f6af3be884c28408759055aba916bf2b120e873c8c780078df3e4468"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ac23d5480bf9f4d897303b6e80ae62fa82bfe3c2387b9590bb79b704e2e437d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2d86d8a76651197afa57107b077cd53bd02ad9891be0523461e04f8d919aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e23e7b843a4ed3370cb2b3020eba83cc594072a460b4c6e2951ccf9fc2c561"
    sha256 cellar: :any_skip_relocation, sonoma:         "86e3c836f33ddaccd72144f244399bdc411a34570454e79627c0babffb6a0b39"
    sha256 cellar: :any_skip_relocation, ventura:        "85040da3385f65ed7015d790da33676f02c60b04e8b7438ce6e936683fb5dc82"
    sha256 cellar: :any_skip_relocation, monterey:       "ac65aac7163152658bf88db79ce4a4a23a84162014dfa9fa9c098b32bdba1ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c1a7b058bdd253fc624ce09f2287b8d0a34b2721cdc26ec1bb9c2395946d82"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end
