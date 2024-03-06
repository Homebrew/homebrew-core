class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.67.1.tar.gz"
  sha256 "072fa1bd9b483b034eed8d150f1ac71734dd088e115a17f67d756bd66ce7469b"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e0436e2c53be6f39c3111037c6e0bbb726d92c8d617efef7eba3eff34514807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9561f3453c54ea3c9849f29d30837aaa54b28962b38138a0fa37eac8b89f787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b62da6cfbbbe6a10603f8bf14af2a9f9e4a185d66b9c078d6bcb84f3ff9ccc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f85bab01b252d3e2dbb7f8acb321baf084cb1d27be75fd40333e6d700549b18"
    sha256 cellar: :any_skip_relocation, ventura:        "f99245fb82792d75ce61d485d39871bc488b184afb76ad822b80d981d7fe4b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "669cb417c2926086484e681c84c8a1525e425344f7bf21a3812d3bfc1c5501c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396ed7c03a6f2bfcd831af657d11d507b91e992855122ef99ab2b25a9e729677"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
