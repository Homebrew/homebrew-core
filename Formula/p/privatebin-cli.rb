class PrivatebinCli < Formula
  desc "CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "cf11851f5e76d7b8d2b90dd662eb0a3dd03cd71f10cad01fb2f81ecf23d303b2"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ed201fc5f15f7c2e698da7958cc3f7850717447d25112de21f178879efd44d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed201fc5f15f7c2e698da7958cc3f7850717447d25112de21f178879efd44d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed201fc5f15f7c2e698da7958cc3f7850717447d25112de21f178879efd44d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e4fa411d88cce37a30da74d468d452692a4837d83655cffc4738bf1b324fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc9373dd412bfa83d39f08fbccd6ab55b0c58f4952d3b8b049c10e8cb2f2448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a98fa2e7050c0484bceb3b221fabfa802f83c5f0a68eebfc5ef0f3485e5d2d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"privatebin"), "./cmd/privatebin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/privatebin --version")

    assert_match "Error: no privatebin instance configured", shell_output("#{bin}/privatebin create foo 2>&1", 1)
  end
end
