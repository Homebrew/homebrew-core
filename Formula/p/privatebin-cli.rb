class PrivatebinCli < Formula
  desc "CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "eb143ed6d2ab88d66e615c5a98fb2c3f8b0ee5a8394590b68ddbf59bfb2c39d3"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb4c13c2f9ea53f51675c8647c55767c74939837c097578ba38d3039e4c2d7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4c13c2f9ea53f51675c8647c55767c74939837c097578ba38d3039e4c2d7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb4c13c2f9ea53f51675c8647c55767c74939837c097578ba38d3039e4c2d7c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91653fc6b2105a834846e498a97865246f173e20a1cc48e30fb2fa2f7b8d192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f4a75e45e63f8228738a2c4d9a6c793465168ee3831ee1c8b8c32b12f8920d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbee2ff0b938abdcb16eeeeafb7b33a77123df28a3615574488104c186cf847"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"privatebin"), "./cmd/privatebin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/privatebin --version")

    assert_match "Error: cannot load configuration", shell_output("#{bin}/privatebin create foo 2>&1", 1)
  end
end
