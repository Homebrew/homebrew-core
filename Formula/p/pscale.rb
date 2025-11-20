class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.261.0.tar.gz"
  sha256 "20c5cf483c6c5edfe3a1c053cb3ce40940e581f7f7a22de4d606f1c75b3a4890"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6fac891edf57a0f48a984991d49f163e24bebda9753b59247f10f35c708aa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be423bf033972e1ed83d07f65ec4fa1c72277615e79e1e4e5908086535d338f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a2f175842cb70f5a309ed1d496bbd7069d0617a48b018258911fa84ca5cb25f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f38b3461a2f7a68843f594474b9938c28e006e2d6c8c66e6f90376c8f4671ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bdb86760f6fc0bc09c731ded452865b2395bbaac502ba450aae8c086accdd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bfa586962ea2837b88019c434b5ff2a7fa1198e720675619bc5c9961edb939"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
