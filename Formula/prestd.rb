class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.7.tar.gz"
  sha256 "8e391129bc8c1f6e6cd6488c58fa79ebdedba271822a0da52edb9170d00f0b76"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e320adf08e40dcedf77c47cdcf49cfdd323602ed26b14f00cf482dcb6fb0db39"
    sha256 cellar: :any_skip_relocation, big_sur:       "55607f36399575f2cfd7714cf519c5cdac435944ecbd61cc415d6876b195d1a6"
    sha256 cellar: :any_skip_relocation, catalina:      "e006dabbaa0ba8c86a51ef0c4441519bfc099ff04719c89abde91a433b16cee1"
    sha256 cellar: :any_skip_relocation, mojave:        "f2c5b3cb1e143efd66fd1c89056ce78d69f5e961afa88076075d971a8ec07f06"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
