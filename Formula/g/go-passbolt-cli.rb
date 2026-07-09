class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "845383bb8c33ec97d1e708a3e5a7a9475c970d977876faa307271d2d6ff77115"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce1d304c7134b22a713f9564449fe90431252528a05206f44de6162476b8758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce1d304c7134b22a713f9564449fe90431252528a05206f44de6162476b8758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce1d304c7134b22a713f9564449fe90431252528a05206f44de6162476b8758"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd353d0c1787eacd08949d92b4574e1fe2bb4cb15c47693284fc40756637a205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c49f1e1192b21ad9fd73c3edf2c640123abf59e292a99e5363559c2300f4dde"
    sha256 cellar: :any,                 x86_64_linux:  "471bd04f8770cb9a34bc15a0223b535454cb3d4911773669bf340358d1fb3115"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", shell_parameter_format: :cobra)
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
